import 'package:flutter/material.dart';
import 'package:todo_alarm/repositories/alarm_localdb_repository.dart';
import 'package:todo_alarm/repositories/alarm_repository.dart';
import 'package:todo_alarm/repositories/model/alarm_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part '../../generated/ui/alarm_display/alarm_display_view_model.g.dart';

@riverpod
class AlarmDisplayViewModel extends _$AlarmDisplayViewModel {
  @override
  Future<AlarmModel?> build() async {
    // Repositoryから初期データを取得
    return _fetchAlarm();
  }

  // プライベートメソッド: データ取得を共通化
  Future<AlarmModel?> _fetchAlarm() async {
    final repository = ref
        .read(alarmLocalDBRepositoryProvider.notifier)
        .build();
    return await repository.getAlarm();
  }

  // View向けのメソッド: 新しいアラームを作成・保存
  Future<void> createAlarm({
    required String todoId,
    required DateTime alarmTime,
    bool isEnabled = true,
    bool isRepeating = false,
    List<int> repeatDays = const [],
    String? sound,
    bool vibrate = true,
    String? label,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref
          .read(alarmLocalDBRepositoryProvider.notifier)
          .build();

      final newAlarm = AlarmModel(
        id: const Uuid().v4(),
        alarmTime: alarmTime,
        isEnabled: isEnabled,
      );

      await repository.saveAlarm(newAlarm);
      return await _fetchAlarm();
    });
  }

  DateTime _timeOfDayToDateTime(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  // View向けのメソッド: アラームの更新
  Future<void> setAlarmTime(DateTime newTime) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref
          .read(alarmLocalDBRepositoryProvider.notifier)
          .build();
      await repository.setDateTime(newTime);
      return await _fetchAlarm();
    });
  }

  // View向けのメソッド: アラーム時刻の変更
  Future<void> updateAlarmTime(TimeOfDay newTime) async {
    final currentAlarm = state.value;
    if (currentAlarm == null) return;

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final alarmLocalDBrepository = ref
          .read(alarmLocalDBRepositoryProvider.notifier)
          .build();

      final alarmRepository = ref.read(alarmRepositoryProvider);

      final DateTime alarmDateTime = _timeOfDayToDateTime(newTime);

      await alarmRepository.setAlarm(alarmDateTime);
      final updatedAlarm = currentAlarm.copyWith(alarmTime: alarmDateTime);
      await alarmLocalDBrepository.saveAlarm(updatedAlarm);
      return await _fetchAlarm();
    });
  }

  // View向けのメソッド: アラームの有効/無効切り替え
  Future<void> toggleEnabled() async {
    final currentAlarm = state.value;
    if (currentAlarm == null) return;

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref
          .read(alarmLocalDBRepositoryProvider.notifier)
          .build();
      final updatedAlarm = currentAlarm.copyWith(
        isEnabled: !currentAlarm.isEnabled,
      );
      await repository.saveAlarm(updatedAlarm);
      return await _fetchAlarm();
    });
  }

  // View向けの便利メソッド: アラームが設定されているか確認
  bool hasAlarm() {
    return state.maybeWhen(data: (alarm) => alarm != null, orElse: () => false);
  }

  // View向けの便利メソッド: アラームが有効か確認
  bool isAlarmEnabled() {
    return state.maybeWhen(
      data: (alarm) => alarm?.isEnabled ?? false,
      orElse: () => false,
    );
  }

  // View向けの便利メソッド: 次のアラーム時刻を取得(表示用)
  String? getNextAlarmTimeFormatted() {
    return state.maybeWhen(
      data: (alarm) {
        if (alarm == null || !alarm.isEnabled) return null;
        // 例: "2025年10月18日 15:30"
        final time = alarm.alarmTime;
        return '${time.year}年${time.month}月${time.day}日 ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      },
      orElse: () => null,
    );
  }
}
