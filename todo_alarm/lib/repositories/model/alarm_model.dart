import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/repositories/model/alarm_model.freezed.dart';
part '../../generated/repositories/model/alarm_model.g.dart';

@freezed
abstract class AlarmModel with _$AlarmModel {
  const factory AlarmModel({
    required String id,
    required DateTime alarmTime, // アラーム時刻
    required bool isEnabled, // アラームの有効/無効
  }) = _AlarmModel;

  factory AlarmModel.fromJson(Map<String, dynamic> json) =>
      _$AlarmModelFromJson(json);
}