import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_alarm/ui/add_todo_item_page/add_todo_item_page.dart';
import 'package:todo_alarm/ui/alarm_todo_page/alarm_todo_page.dart';

void main() {
  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/alarm_todo': (context) => AlarmTodoPage(),
        '/add_todo': (context) => AddTodoItemPage(),
      },
      home: AlarmTodoPage(),
    );
  }
}
