import 'package:todo_alarm/repositories/todo_localdb_repository.dart';
import 'package:todo_alarm/repositories/model/todo_item_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part '../../generated/ui/todo_list/todo_list_view_model.g.dart';

@riverpod
class TodoListViewModel extends _$TodoListViewModel {
  @override
  Future<List<TodoItemModel>> build() async {
    // Repositoryから初期データを取得
    return _fetchTodos();
  }

  // プライベートメソッド: データ取得を共通化
  Future<List<TodoItemModel>> _fetchTodos() async {
    final repository = ref.read(todoLocalDbRepositoryProvider.notifier).build();
    return await repository.getTodos();
  }

  // View向けのメソッド: タイトルから新しいTodoを追加
  Future<void> addTodoFromTitle(String title) async {
    if (title.trim().isEmpty) {
      // 空の場合は何もしない(Viewでバリデーションしても良い)
      return;
    }

    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(todoLocalDbRepositoryProvider.notifier).build();
      
      // ViewModelでTodoItemModelを生成(Viewは構造を知らなくて良い)
      final newTodo = TodoItemModel(
        id: const Uuid().v4(),
        title: title.trim(),
        isCompleted: false,
      );
      
      await repository.addTodo(newTodo);
      return await _fetchTodos();
    });
  } 

  // View向けのメソッド: Todoの更新
  Future<void> updateTodo(TodoItemModel todo) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(todoLocalDbRepositoryProvider.notifier).build();
      await repository.updateTodo(todo);
      return await _fetchTodos();
    });
  }

  // View向けのメソッド: Todoの削除
  Future<void> deleteTodo(String id) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(todoLocalDbRepositoryProvider.notifier).build();
      await repository.deleteTodo(id);
      return await _fetchTodos();
    });
  }
  
  // View向けのメソッド: 完了状態のトグル
  Future<void> toggleCompleted(String id) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(todoLocalDbRepositoryProvider.notifier).build();
      await repository.toggleCompleted(id);
      return await _fetchTodos();
    });
  }

  // View向けの便利メソッド: 完了済みTodoの件数を取得
  int getCompletedCount() {
    return state.maybeWhen(
      data: (todos) => todos.where((todo) => todo.isCompleted).length,
      orElse: () => 0,
    );
  }

  // View向けの便利メソッド: 未完了Todoの件数を取得
  int getIncompleteCount() {
    return state.maybeWhen(
      data: (todos) => todos.where((todo) => !todo.isCompleted).length,
      orElse: () => 0,
    );
  }

  // View向けの便利メソッド: フィルタリングされたTodoリストを取得
  List<TodoItemModel> getFilteredTodos({required bool showCompleted}) {
    return state.maybeWhen(
      data: (todos) => todos.where((todo) => 
        showCompleted ? todo.isCompleted : !todo.isCompleted
      ).toList(),
      orElse: () => [],
    );
  }
}
