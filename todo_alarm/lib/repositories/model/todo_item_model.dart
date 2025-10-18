import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/repositories/model/todo_item_model.freezed.dart';
part '../../generated/repositories/model/todo_item_model.g.dart';

@freezed
abstract class TodoItemModel with _$TodoItemModel {
  const factory TodoItemModel({
    required String id,
    required String title,
    required bool isCompleted,
  }) = _TodoItemModel;

  factory TodoItemModel.fromJson(Map<String, dynamic> json) =>
      _$TodoItemModelFromJson(json);
}
