import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_alarm/ui/todo_list/todo_list_view_model.dart';

class AddTodoItemPage extends HookConsumerWidget {
  const AddTodoItemPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();

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
            ElevatedButton(
              onPressed: () async {
                final title = textController.text.trim();
                if (title.isNotEmpty) {
                  await ref
                      .read(todoListViewModelProvider.notifier)
                      .addTodoFromTitle(title);
                  
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
}
