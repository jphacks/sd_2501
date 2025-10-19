import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class DiscordWebhookService {
  final String _webhookUrl;

  /// Webhook URLを受け取る
  DiscordWebhookService({required String webhookUrl})
    : _webhookUrl = webhookUrl;

  /// [username]：Discordで表示されるボットの名前。
  /// [text]：送信したいメッセージの本文。
  ///
  /// 成功した場合はtrue、失敗した場合はfalse
  Future<bool> send({
    required String username,
    required String text,
    String? avatarUrl, // 必要に応じてアバターURLも追加
  }) async {
    try {
      final Uri url = Uri.parse(_webhookUrl);

      // Webhookのペイロード（送信データ）を作成
      final Map<String, dynamic> postData = {
        "username": username,
        "content": text,
      };
      // オプションのアバターURLを追加
      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        postData["avatar_url"] = avatarUrl;
      }

      // HTTPリクエストのヘッダーを設定
      final Map<String, String> headers = {'content-type': 'application/json'};

      // リクエストボディをJSON文字列にエンコード
      final String body = jsonEncode(postData);

      // HTTP POSTリクエストを送信
      final http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      // 応答ステータスコードをチェック
      if (response.statusCode == 204) {
        // Discord Webhookの成功は 204 No Content
        if (kDebugMode) {
          print('true');
        }
        return true;
      } else {
        // エラー応答の処理
        if (kDebugMode) {
          print('false');
          print('Status Code: ${response.statusCode}');
          print('Response Body: ${response.body}');
        }
        return false;
      }
    } catch (e) {
      // ネットワークやその他の予期せぬエラーを捕捉
      if (kDebugMode) {
        print('false: $e');
      }
      return false;
    }
  }
}
