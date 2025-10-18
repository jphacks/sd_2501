import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_alarm/ui/todo_list/todo_list_view_model.dart';

class TodoList extends HookConsumerWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todoListViewModelProvider);

    return todosAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('エラーが発生しました: $error'),
      ),
      data: (todos) {
        if (todos.isEmpty) {
          return const Center(child: Text('Todoがありません'));
        }

        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                child: ListTile(
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isCompleted 
                        ? TextDecoration.lineThrough 
                        : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      ref.read(todoListViewModelProvider.notifier)
                        .deleteTodo(todo.id);
                    },
                  ),
                  leading: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (value) {
                      ref.read(todoListViewModelProvider.notifier)
                        .toggleCompleted(todo.id);
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
