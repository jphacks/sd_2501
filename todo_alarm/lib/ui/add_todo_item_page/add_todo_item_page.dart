import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddTodoItemPage extends HookConsumerWidget {
  const AddTodoItemPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todoアイテムを追加')),
      body: Padding(
        padding: EdgeInsetsGeometry.all(16.0),
        child: Column(
          children: [
            TextField(decoration: const InputDecoration(labelText: 'やること')),
            SizedBox(height: 16.0),
            ElevatedButton(onPressed: () {}, child: const Text('追加')),
          ],
        ),
      ),
    );
  }
}
