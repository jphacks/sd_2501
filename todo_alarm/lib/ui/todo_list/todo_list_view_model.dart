import 'package:todo_alarm/repositories/todo_localdb_repository.dart';
import 'package:todo_alarm/repositories/model/todo_item_model.dart';
import 'package:todo_alarm/repositories/model/todo_status.dart';
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
      return;
    }

    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(todoLocalDbRepositoryProvider.notifier).build();
      
      final newTodo = TodoItemModel(
        id: const Uuid().v4(),
        title: title.trim(),
        status: TodoStatus.notStarted,
      );
      
      await repository.addTodo(newTodo);
      return await _fetchTodos();
    });
  }

  // 状態を変更するメソッド
  Future<void> updateStatus(String id, TodoStatus newStatus) async {
    state = const AsyncValue.loading();
    
    state = await AsyncValue.guard(() async {
      final repository = ref.read(todoLocalDbRepositoryProvider.notifier).build();
      await repository.updateStatus(id, newStatus);
      return await _fetchTodos();
    });
  }

  // 取り組み中にする
  Future<void> markAsInProgress(String id) async {
    await updateStatus(id, TodoStatus.inProgress);
  }

  // 完了にする
  Future<void> markAsCompleted(String id) async {
    await updateStatus(id, TodoStatus.completed);
  }

  // 未完了に戻す
  Future<void> markAsNotStarted(String id) async {
    await updateStatus(id, TodoStatus.notStarted);
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
      final todos = await repository.getTodos();
      final todo = todos.firstWhere((t) => t.id == id);

      // 完了 → 未完了、未完了・取り組み中 → 完了のトグル
      final newStatus = todo.isCompleted
          ? TodoStatus.notStarted
          : TodoStatus.completed;

      await repository.updateStatus(id, newStatus);
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

  // View向けの便利メソッド: ステータス別の件数を取得
  int getCountByStatus(TodoStatus status) {
    return state.maybeWhen(
      data: (todos) => todos.where((todo) => todo.status == status).length,
      orElse: () => 0,
    );
  }

  // View向けの便利メソッド: フィルタリングされたTodoリストを取得
  List<TodoItemModel> getFilteredTodos({TodoStatus? status}) {
    return state.maybeWhen(
      data: (todos) => status == null 
          ? todos 
          : todos.where((todo) => todo.status == status).toList(),
      orElse: () => [],
    );
  }
}
