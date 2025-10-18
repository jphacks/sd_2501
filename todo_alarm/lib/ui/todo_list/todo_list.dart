import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TodoList extends HookConsumerWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            child: ListTile(
              title: Text('Todo $index'),
              trailing: IconButton(icon: Icon(Icons.delete), onPressed: () {}),
              leading: Checkbox(value: false, onChanged: (value) {}),
            ),
          ),
        );
      },

      itemCount: 10,
    );
  }
}
