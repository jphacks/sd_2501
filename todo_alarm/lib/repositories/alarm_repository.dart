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
    id: 1,
    dateTime: DateTime.now().add(Duration(seconds: 10)),
    loopAudio: true,
    vibrate: true,
    assetAudioPath: 'assets/alarms/alarm.mp3',
    volumeSettings: VolumeSettings.fade(
      volume: 0.8,
      fadeDuration: Duration(seconds: 5),
      volumeEnforced: true,
    ),
    notificationSettings: const NotificationSettings(
      title: 'This is the title',
      body: 'アプリを開きアラームを停止してください',
      icon: 'notification_icon',
      iconColor: Color(0xff862778),
    ),
  );

  Future<void> setAlarm(DateTime dateTime, String title) async {
    await Alarm.set(
      alarmSettings: alarmSettings.copyWith(
        id: 0,
        dateTime: dateTime,
        notificationSettings: alarmSettings.notificationSettings.copyWith(
          title: title,
        ),
      ),
    );
  }

  Future<void> stopAlarm() async {
    await Alarm.stop(0);
  }
}
