import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_alarm/ui/todo_list/todo_list_view_model.dart';

class AddTodoItemPage extends HookConsumerWidget {
  const AddTodoItemPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();
    final selectedDeadline = useState<DateTime?>(null);

    Future<void> selectDeadline() async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );

      if (pickedDate != null && context.mounted) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          selectedDeadline.value = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Todoアイテムを追加')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: 'やること',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16.0),
            // 期限設定ボタン
            OutlinedButton.icon(
              onPressed: selectDeadline,
              icon: const Icon(Icons.calendar_today),
              label: Text(
                selectedDeadline.value == null
                    ? '期限を設定（任意）'
                    : '期限: ${_formatDeadline(selectedDeadline.value!)}',
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            if (selectedDeadline.value != null) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => selectedDeadline.value = null,
                icon: const Icon(Icons.clear),
                label: const Text('期限をクリア'),
              ),
            ],
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final title = textController.text.trim();
                if (title.isNotEmpty) {
                  await ref
                      .read(todoListViewModelProvider.notifier)
                      .addTodoFromTitle(
                        title,
                        deadline: selectedDeadline.value,
                      );

                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
              child: const Text('追加'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDeadline(DateTime deadline) {
    return '${deadline.year}/${deadline.month}/${deadline.day} '
        '${deadline.hour.toString().padLeft(2, '0')}:${deadline.minute.toString().padLeft(2, '0')}';
  }
}
