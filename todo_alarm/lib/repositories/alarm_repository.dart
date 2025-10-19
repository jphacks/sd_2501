import 'dart:ui';

import 'package:alarm/alarm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../generated/repositories/alarm_repository.g.dart';

@riverpod
class AlarmRepository extends _$AlarmRepository {
  @override
  AlarmRepositoryImpl build() {
    return AlarmRepositoryImpl();
  }
}

class AlarmRepositoryImpl {
  final AlarmSettings alarmSettings = AlarmSettings(
    id: 1, // IDは1以上の正の整数が必要（0と-1は使用不可）
    dateTime: DateTime.now().add(Duration(seconds: 10)),
    loopAudio: true,
    vibrate: true,
    assetAudioPath: 'assets/alarms/bell.mp3',
    volumeSettings: VolumeSettings.fade(
      volume: 0.8,
      fadeDuration: Duration(seconds: 5),
      volumeEnforced: true,
    ),
    notificationSettings: const NotificationSettings(
      title: 'おはようございます！',
      body: 'アプリを開きアラームを停止してください',
      icon: 'notification_icon',
      iconColor: Color(0xff862778),
    ),
  );

  Future<void> setAlarm(DateTime dateTime) async {
    print("repositories/alarm_repository.dart: Setting alarm for $dateTime");

    // 現在時刻との差分を確認
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    print(
      "repositories/alarm_repository.dart: Alarm will ring in ${difference.inHours}h ${difference.inMinutes % 60}m ${difference.inSeconds % 60}s",
    );

    try {
      final settings = alarmSettings.copyWith(id: 1, dateTime: dateTime);
      print(
        "repositories/alarm_repository.dart: Alarm settings: assetAudioPath=${settings.assetAudioPath}, vibrate=${settings.vibrate}",
      );

      await Alarm.set(alarmSettings: settings);
      print(
        "repositories/alarm_repository.dart: Alarm.set() completed successfully",
      );

      // 設定されたアラームの一覧を確認
      final alarms = await Alarm.getAlarms();
      print(
        "repositories/alarm_repository.dart: Total alarms set: ${alarms.length}",
      );
      if (alarms.isNotEmpty) {
        print(
          "repositories/alarm_repository.dart: Alarm ID ${alarms.first.id} set for ${alarms.first.dateTime}",
        );
      } else {
        print(
          "repositories/alarm_repository.dart: WARNING: No alarms found after setting!",
        );
      }

      print("repositories/alarm_repository.dart: Setting alarm completed");
    } catch (e, stackTrace) {
      print("repositories/alarm_repository.dart: ERROR setting alarm: $e");
      print("repositories/alarm_repository.dart: Stack trace: $stackTrace");
      rethrow;
    }
  }

  Future<void> stopAlarm() async {
    await Alarm.stop(1); // 設定時と同じIDを使用
  }
}
