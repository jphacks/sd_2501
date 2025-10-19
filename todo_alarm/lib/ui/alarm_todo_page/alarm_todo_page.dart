import 'package:flutter/material.dart';
import 'package:todo_alarm/repositories/alarm_permission.dart';
import 'package:todo_alarm/ui/alarm_display/alarm_display.dart';
import 'package:todo_alarm/ui/todo_list/todo_list.dart';
import 'package:todo_alarm/ui/settings/settings_page.dart';

class AlarmTodoPage extends StatelessWidget {
  const AlarmTodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    AlarmPermissions.checkNotificationPermission().then(
      (_) => AlarmPermissions.checkAndroidScheduleExactAlarmPermission(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/appbar_logo.png', height: 30),
        leading: IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
            tooltip: '設定',
          ),
        actions: [
          // 音声認識ボタン
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () {
              Navigator.pushNamed(context, '/voice_recognition');
            },
            tooltip: '音声認識',
          ),
          // 設定ボタン（歯車アイコン）
          
        ],
      ),
      body: Column(
        children: [
          AlarmDisplay(),
          Expanded(child: TodoList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_todo');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
