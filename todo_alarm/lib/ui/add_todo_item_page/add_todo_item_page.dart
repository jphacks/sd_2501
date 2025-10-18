import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddTodoItemPage extends HookConsumerWidget {
  const AddTodoItemPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todoアイテムを追加')),
      body: Column(
        children: [
          TextField(decoration: const InputDecoration(labelText: 'やること')),
          ElevatedButton(onPressed: () {}, child: const Text('追加')),
        ],
      ),
    );
  }
}
