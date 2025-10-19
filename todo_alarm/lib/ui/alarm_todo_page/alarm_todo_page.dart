import 'package:flutter/material.dart';
import 'package:todo_alarm/ui/alarm_display/alarm_display.dart';
import 'package:todo_alarm/ui/todo_list/todo_list.dart';

class AlarmTodoPage extends StatelessWidget {
  const AlarmTodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm Todo Page'),
        actions: [
          // 音声認識ボタンを追加
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () {
              Navigator.pushNamed(context, '/voice_recognition');
            },
            tooltip: '音声認識',
          ),
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
