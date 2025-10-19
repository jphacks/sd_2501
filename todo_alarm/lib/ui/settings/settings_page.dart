import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  static const String _webhookUrlKey = 'webhook_url';

  // メソッドをstaticに変更
  static Future<String?> _loadWebhookUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_webhookUrlKey);
  }

  static Future<void> _saveWebhookUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_webhookUrlKey, url);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();
    final isSaved = useState(false);

    // 初回表示時に保存されているURLを読み込む
    useEffect(() {
      _loadWebhookUrl().then((url) {
        if (url != null) {
          textController.text = url;
        }
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Webhook URL',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Discord WebhookなどのURLを入力してください',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: 'URL',
                hintText: 'https://discord.com/api/webhooks/...',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.link),
                suffixIcon: isSaved.value
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
              ),
              keyboardType: TextInputType.url,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final url = textController.text.trim();
                  if (url.isNotEmpty) {
                    await _saveWebhookUrl(url);
                    isSaved.value = true;

                    // 2秒後に保存完了メッセージを消す
                    Future.delayed(const Duration(seconds: 2), () {
                      isSaved.value = false;
                    });

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('URLを保存しました'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text('保存'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (textController.text.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    textController.clear();
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove(_webhookUrlKey);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('URLをクリアしました'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text('クリア'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}