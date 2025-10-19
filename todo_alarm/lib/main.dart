import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todo_alarm/ui/add_todo_item_page/add_todo_item_page.dart';
import 'package:todo_alarm/ui/alarm_todo_page/alarm_todo_page.dart';
import 'package:todo_alarm/ui/ringing_alarm_page/ringing_alarm_page.dart';
import 'package:todo_alarm/ui/voice_recognition/voice_recognition_page.dart';


// グローバルナビゲーターキー
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  // Flutterのバインディングを初期化
  WidgetsFlutterBinding.ensureInitialized();

  // Alarmパッケージの初期化（これがないとアラームが鳴らない）
  await Alarm.init();

  // アラームが鳴った時のリスナーを設定（新しいAPIを使用）
  Alarm.ringing.listen((alarmSet) {
    print(
      'main.dart: 🔔 ALARM IS RINGING! AlarmSet: ${alarmSet.alarms.length} alarms',
    );

    // アラーム画面を表示
    // alarmSet.alarms には現在鳴っているアラームのリストが入っている
    if (alarmSet.alarms.isNotEmpty) {
      final firstAlarm = alarmSet.alarms.first;
      print(
        'main.dart: Showing alarm screen for ID: ${firstAlarm.id}, Time: ${firstAlarm.dateTime}',
      );

      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => VoiceRecognitionPage(),
          fullscreenDialog: true, // フルスクリーンで表示
        ),
      );
    }
  });

  // Android 12+ で必要な正確なアラームのスケジュール権限を確認
  await _checkPermissions();
  runApp(ProviderScope(child: MainApp()));
}

Future<void> _checkPermissions() async {
  // 通知権限をリクエスト
  final notificationStatus = await Permission.notification.status;
  print('main.dart: Notification permission: $notificationStatus');
  if (notificationStatus.isDenied) {
    print('main.dart: Requesting notification permission...');
    await Permission.notification.request();
  }

  // Android 12+ で正確なアラームのスケジュール権限を確認
  final scheduleStatus = await Permission.scheduleExactAlarm.status;
  print('main.dart: Schedule exact alarm permission: $scheduleStatus');
  if (scheduleStatus.isDenied) {
    print('main.dart: Requesting schedule exact alarm permission...');
    final result = await Permission.scheduleExactAlarm.request();
    print(
      'main.dart: Schedule exact alarm permission ${result.isGranted ? "granted" : "denied"}',
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // グローバルキーを設定
      routes: {
        '/alarm_todo': (context) => AlarmTodoPage(),
        '/add_todo': (context) => AddTodoItemPage(),
        '/voice_recognition': (context) => VoiceRecognitionPage(),
      },
      home: AlarmTodoPage(),
    );
  }
}
