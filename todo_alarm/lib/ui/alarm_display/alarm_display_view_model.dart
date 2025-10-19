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
    if (!ref.mounted) return null;

    final repository = ref
        .read(alarmLocalDBRepositoryProvider.notifier)
        .build();

    print("ui/alarm_display/alarm_display_view_model.dart: Fetched alarm data");
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

    try {
      final repository = ref
          .read(alarmLocalDBRepositoryProvider.notifier)
          .build();

      final newAlarm = AlarmModel(
        id: const Uuid().v4(),
        alarmTime: alarmTime,
        isEnabled: isEnabled,
      );

      await repository.saveAlarm(newAlarm);

      // 保存したデータを直接返す
      final result = await repository.getAlarm();

      if (ref.mounted) {
        state = AsyncValue.data(result);
      }
    } catch (error, stackTrace) {
      if (ref.mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }

  DateTime _timeOfDayToDateTime(TimeOfDay time) {
    final now = DateTime.now();
    var alarmDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // 選択した時刻が現在時刻より前の場合は、翌日に設定
    if (alarmDateTime.isBefore(now)) {
      alarmDateTime = alarmDateTime.add(Duration(days: 1));
      print(
        "ui/alarm_display/alarm_display_view_model.dart: Selected time is in the past, setting for tomorrow: $alarmDateTime",
      );
    }

    return alarmDateTime;
  }

  // View向けのメソッド: アラームの更新
  Future<void> setAlarmTime(DateTime newTime) async {
    state = const AsyncValue.loading();

    try {
      final repository = ref
          .read(alarmLocalDBRepositoryProvider.notifier)
          .build();

      await repository.setDateTime(newTime);
      print(
        "ui/alarm_display/alarm_display_view_model.dart: Updated alarm time to $newTime",
      );

      final result = await repository.getAlarm();

      if (ref.mounted) {
        state = AsyncValue.data(result);
      }
    } catch (error, stackTrace) {
      if (ref.mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }

  // View向けのメソッド: アラーム時刻の変更
  Future<void> updateAlarmTime(TimeOfDay newTime) async {
    final currentAlarm = state.value;

    state = const AsyncValue.loading();

    try {
      final alarmLocalDBrepository = ref
          .read(alarmLocalDBRepositoryProvider.notifier)
          .build();
      final alarmRepository = ref.read(alarmRepositoryProvider);

      final DateTime alarmDateTime = _timeOfDayToDateTime(newTime);

      print(
        "ui/alarm_display/alarm_display_view_model.dart: Updating alarm time to $alarmDateTime",
      );

      // alarmRepositoryでアラームを設定（これが実際にアラームを鳴らすために必要）
      await alarmRepository.setAlarm(alarmDateTime);

      // アラームが存在しない場合は新規作成、存在する場合は更新
      if (currentAlarm == null) {
        // 新規作成
        final newAlarm = AlarmModel(
          id: const Uuid().v4(),
          alarmTime: alarmDateTime,
          isEnabled: true,
        );
        await alarmLocalDBrepository.saveAlarm(newAlarm);
        print(
          "ui/alarm_display/alarm_display_view_model.dart: Created new alarm",
        );
      } else {
        // 既存のアラームを更新
        final updatedAlarm = currentAlarm.copyWith(alarmTime: alarmDateTime);
        await alarmLocalDBrepository.saveAlarm(updatedAlarm);
        print(
          "ui/alarm_display/alarm_display_view_model.dart: Updated existing alarm",
        );
      }

      final result = await alarmLocalDBrepository.getAlarm();

      if (ref.mounted) {
        state = AsyncValue.data(result);
      }
    } catch (error, stackTrace) {
      if (ref.mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }

  // View向けのメソッド: アラームの有効/無効切り替え
  Future<void> toggleEnabled() async {
    final currentAlarm = state.value;
    if (currentAlarm == null) return;

    state = const AsyncValue.loading();

    try {
      final repository = ref
          .read(alarmLocalDBRepositoryProvider.notifier)
          .build();

      final updatedAlarm = currentAlarm.copyWith(
        isEnabled: !currentAlarm.isEnabled,
      );
      await repository.saveAlarm(updatedAlarm);

      final result = await repository.getAlarm();

      if (ref.mounted) {
        state = AsyncValue.data(result);
      }
    } catch (error, stackTrace) {
      if (ref.mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
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

  // カウントダウンでアラームを設定
  Future<void> setCountdownAlarm(int seconds) async {
    state = const AsyncValue.loading();

    try {
      final repository = ref
          .read(alarmLocalDBRepositoryProvider.notifier)
          .build();
      final alarmRepository = ref
          .read(alarmRepositoryProvider.notifier)
          .build();

      // 現在時刻から指定秒数後のDateTimeを計算
      final alarmDateTime = DateTime.now().add(Duration(seconds: seconds));

      print(
        "ui/alarm_display/alarm_display_view_model.dart: Setting countdown alarm for $seconds seconds (at $alarmDateTime)",
      );

      // アラームを設定
      await alarmRepository.setAlarm(alarmDateTime);

      // カウントダウン情報を保存
      await repository.setCountdownSeconds(seconds);
      await repository.setIsCountdownMode(true);

      // アラームモデルを作成・保存
      final currentAlarm = await repository.getAlarm();
      if (currentAlarm == null) {
        final newAlarm = AlarmModel(
          id: const Uuid().v4(),
          alarmTime: alarmDateTime,
          isEnabled: true,
        );
        await repository.saveAlarm(newAlarm);
      } else {
        final updatedAlarm = currentAlarm.copyWith(alarmTime: alarmDateTime);
        await repository.saveAlarm(updatedAlarm);
      }

      final result = await repository.getAlarm();
      if (ref.mounted) {
        state = AsyncValue.data(result);
      }

      print("ui/alarm_display/alarm_display_view_model.dart: Countdown alarm set successfully");
    } catch (error, stackTrace) {
      if (ref.mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }

  // カウントダウンをキャンセル
  Future<void> cancelCountdown() async {
    state = const AsyncValue.loading();

    try {
      final repository = ref
          .read(alarmLocalDBRepositoryProvider.notifier)
          .build();
      final alarmRepository = ref
          .read(alarmRepositoryProvider.notifier)
          .build();

      // アラームを停止
      await alarmRepository.stopAlarm();

      // カウントダウンモードをオフ
      await repository.setIsCountdownMode(false);

      final result = await repository.getAlarm();
      if (ref.mounted) {
        state = AsyncValue.data(result);
      }

      print("ui/alarm_display/alarm_display_view_model.dart: Countdown cancelled");
    } catch (error, stackTrace) {
      if (ref.mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }

  // カウントダウンモードかどうかを確認
  Future<bool> isCountdownMode() async {
    final repository = ref
        .read(alarmLocalDBRepositoryProvider.notifier)
        .build();
    return await repository.getIsCountdownMode();
  }

  // 残り時間を取得（秒）
  int? getRemainingSeconds() {
    return state.maybeWhen(
      data: (alarm) {
        if (alarm == null || !alarm.isEnabled) return null;
        final now = DateTime.now();
        final difference = alarm.alarmTime.difference(now);
        return difference.inSeconds > 0 ? difference.inSeconds : 0;
      },
      orElse: () => null,
    );
  }
}
