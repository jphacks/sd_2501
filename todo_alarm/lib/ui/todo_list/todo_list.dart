import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_alarm/ui/todo_list/todo_list_view_model.dart';
import 'package:todo_alarm/repositories/model/todo_status.dart';
import 'package:todo_alarm/repositories/model/todo_item_model.dart';

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
                      fontWeight: todo.isInProgress 
                        ? FontWeight.bold 
                        : FontWeight.normal,
                    ),
                  ),
                  // ステータスを表示
                  subtitle: Row(
                    children: [
                      _buildStatusChip(todo.status),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 削除ボタンのみ
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          ref.read(todoListViewModelProvider.notifier)
                            .deleteTodo(todo.id);
                        },
                      ),
                    ],
                  ),
                  // チェックボックスは完了⇔未完了のトグルのみ
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

  // ステータスチップを作成
  Widget _buildStatusChip(TodoStatus status) {
    Color color;
    IconData icon;
    
    switch (status) {
      case TodoStatus.notStarted:
        color = Colors.grey;
        icon = Icons.radio_button_unchecked;
        break;
      case TodoStatus.inProgress:
        color = Colors.orange;
        icon = Icons.play_circle_outline;
        break;
      case TodoStatus.completed:
        color = Colors.green;
        icon = Icons.check_circle;
        break;
    }
    
    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(
        status.displayName,
        style: TextStyle(fontSize: 12, color: color),
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
