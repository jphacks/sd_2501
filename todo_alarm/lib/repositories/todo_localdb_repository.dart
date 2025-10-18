import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/todo_item_model.dart';
import 'model/todo_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../generated/repositories/todo_localdb_repository.g.dart';

@riverpod
class TodoLocalDbRepository extends _$TodoLocalDbRepository {
  @override
  TodoLocalDbRepositoryImpl build() {
    return TodoLocalDbRepositoryImpl();
  }
}

class TodoLocalDbRepositoryImpl {
  Future<List<TodoItemModel>> getTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todosJson = prefs.getString('todos');
    if (todosJson != null) {
      final List<dynamic> todoList = json.decode(todosJson);
      return todoList.map((todo) => TodoItemModel.fromJson(todo)).toList();
    }
    return [];
  }

  Future<void> addTodo(TodoItemModel todo) async {
    final prefs = await SharedPreferences.getInstance();
    final todos = await getTodos();
    todos.add(todo);
    await prefs.setString('todos', json.encode(todos));
  }

  Future<void> updateTodo(TodoItemModel todo) async {
    final prefs = await SharedPreferences.getInstance();
    final todos = await getTodos();
    final index = todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      todos[index] = todo;
      await prefs.setString('todos', json.encode(todos));
    }
  }

  Future<void> deleteTodo(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final todos = await getTodos();
    todos.removeWhere((t) => t.id == id);
    await prefs.setString('todos', json.encode(todos));
  }

  Future<void> updateStatus(String id, TodoStatus newStatus) async {
    final prefs = await SharedPreferences.getInstance();
    final todos = await getTodos();
    final index = todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      todos[index] = todos[index].copyWith(status: newStatus);
      await prefs.setString('todos', json.encode(todos));
    }
  }

  Future<void> markAsInProgress(String id) async {
    await updateStatus(id, TodoStatus.inProgress);
  }

  Future<void> markAsCompleted(String id) async {
    await updateStatus(id, TodoStatus.completed);
  }

  Future<void> markAsNotStarted(String id) async {
    await updateStatus(id, TodoStatus.notStarted);
  }

  Future<void> toggleCompleted(String id) async {
    final todos = await getTodos();
    final todo = todos.firstWhere((t) => t.id == id);

    // 未完了 → 完了、完了 → 未完了のトグル
    final newStatus = todo.isCompleted
        ? TodoStatus.notStarted
        : TodoStatus.completed;

    await updateStatus(id, newStatus);
  }
}
