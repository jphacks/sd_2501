import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/repositories/model/voice_model.freezed.dart';
part '../../generated/repositories/model/voice_model.g.dart';

@freezed
abstract class VoiceModel with _$VoiceModel {
  const factory VoiceModel({
    required String id,
    required String recognizedText, // 認識されたテキスト
    required DateTime recordedAt, // 記録日時
    required bool isMatched, // Todoと一致したかどうか
    String? matchedTodoId, // 一致したTodoのID（オプション）
  }) = _VoiceModel;

  factory VoiceModel.fromJson(Map<String, dynamic> json) =>
      _$VoiceModelFromJson(json);
}