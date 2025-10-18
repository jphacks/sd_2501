// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../repositories/model/alarm_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AlarmModel _$AlarmModelFromJson(Map<String, dynamic> json) => _AlarmModel(
  id: json['id'] as String,
  alarmTime: DateTime.parse(json['alarmTime'] as String),
  isEnabled: json['isEnabled'] as bool,
);

Map<String, dynamic> _$AlarmModelToJson(_AlarmModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'alarmTime': instance.alarmTime.toIso8601String(),
      'isEnabled': instance.isEnabled,
    };
