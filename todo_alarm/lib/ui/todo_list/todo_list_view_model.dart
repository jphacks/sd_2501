import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_alarm/repositories/todo_localdb_repository.dart';
import 'package:todo_alarm/repositories/model/todo_item_model.dart';
import 'package:todo_alarm/repositories/model/todo_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/services/discord_webhook_service.dart';
import 'package:uuid/uuid.dart';

part '../../generated/ui/todo_list/todo_list_view_model.g.dart';

@riverpod
class TodoListViewModel extends _$TodoListViewModel {
  @override
  Future<List<TodoItemModel>> build() async {
    // 期限切れチェックを開始
    _startDeadlineCheck();
    // Repositoryから初期データを取得
    return _fetchTodos();
  }

  static const String _webhookUrlKey = 'webhook_url';

  // メソッドをstaticに変更
  static Future<String?> _loadWebhookUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_webhookUrlKey);
  }

  // プライベートメソッド: データ取得を共通化
  Future<List<TodoItemModel>> _fetchTodos() async {
    final repository = ref.read(todoLocalDbRepositoryProvider.notifier).build();
    return await repository.getTodos();
  }

  // 期限切れチェックを定期的に実行
  void _startDeadlineCheck() {
    // 1分ごとに期限切れをチェック
    Future.delayed(const Duration(minutes: 1), () async {
      if (!ref.mounted) return;
      await _checkAndUpdateOverdueTodos();
      _startDeadlineCheck(); // 再帰的に呼び出し
    });
  }

  // 期限切れTodoをチェックして更新
  Future<void> _checkAndUpdateOverdueTodos() async {
    final todos = await _fetchTodos();
    final now = DateTime.now();

    for (final todo in todos) {
      // 期限があり、完了していない、かつ現在時刻が期限を過ぎている場合
      if (todo.deadline != null &&
          !todo.isCompleted &&
          now.isAfter(todo.deadline!) &&
          todo.status != TodoStatus.overdue) {
        // 期限切れに変更
        await updateStatus(todo.id, TodoStatus.overdue);

        // Discordに通知
        final webhookUrl = await _loadWebhookUrl();
        if (webhookUrl != null && webhookUrl.isNotEmpty) {
          print('Sending Discord webhook for overdue todo: ${todo.title}');
          final discordService = DiscordWebhookService(webhookUrl: webhookUrl);
          await discordService.send(text: '⏰ 期限切れ: ${todo.title}');
        }
      }
    }
  }

  // View向けのメソッド: タイトルと期限から新しいTodoを追加
  Future<void> addTodoFromTitle(String title, {DateTime? deadline}) async {
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
        deadline: deadline,
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
      final oldStatus = todo.status;

      // 期限切れの場合はトグルできない
      if (todo.status == TodoStatus.overdue) {
        return await _fetchTodos();
      }

      // 完了 → 未完了、未完了・取り組み中 → 完了のトグル
      final newStatus = todo.isCompleted
          ? TodoStatus.notStarted
          : TodoStatus.completed;

      if (!todo.isCompleted) {
        final webhookUrl = await _loadWebhookUrl();
        print("Webhook URL: $webhookUrl");
        if (webhookUrl != null && webhookUrl.isNotEmpty) {
          print('Sending Discord webhook for completed todo: ${todo.title}');
          final discordService = DiscordWebhookService(webhookUrl: webhookUrl);
          await discordService.send(text: '✅ Todo完了: ${todo.title}');
        }
      }
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
