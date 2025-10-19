import 'package:freezed_annotation/freezed_annotation.dart';
import 'todo_status.dart'; // この行を追加

part '../../generated/repositories/model/todo_item_model.freezed.dart';
part '../../generated/repositories/model/todo_item_model.g.dart';

@freezed
abstract class TodoItemModel with _$TodoItemModel {
  const factory TodoItemModel({
    required String id,
    required String title,
    @Default(TodoStatus.notStarted) TodoStatus status, // isCompleted から status に変更
  }) = _TodoItemModel;

  factory TodoItemModel.fromJson(Map<String, dynamic> json) =>
      _$TodoItemModelFromJson(json);
}

// 便利な拡張メソッド
extension TodoItemModelX on TodoItemModel {
  bool get isCompleted => status == TodoStatus.completed;
  bool get isInProgress => status == TodoStatus.inProgress;
  bool get isNotStarted => status == TodoStatus.notStarted;
}
