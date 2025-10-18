import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/todo_item_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_localdb_repository.g.dart';

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
      return todoList
          .map((todo) => TodoItemModel.fromJson(todo))
          .toList();
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

  Future<void> toggleCompleted(String id) async {
  final prefs = await SharedPreferences.getInstance();
  final todos = await getTodos();
  final index = todos.indexWhere((t) => t.id == id);
  if (index != -1) {
    todos[index] = todos[index].copyWith(
      isCompleted: !todos[index].isCompleted,
    );
    await prefs.setString('todos', json.encode(todos));
    }
  }
}
