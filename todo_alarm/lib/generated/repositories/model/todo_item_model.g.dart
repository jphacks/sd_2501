// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../repositories/model/todo_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TodoItemModel _$TodoItemModelFromJson(Map<String, dynamic> json) =>
    _TodoItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool,
    );

Map<String, dynamic> _$TodoItemModelToJson(_TodoItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'isCompleted': instance.isCompleted,
    };
