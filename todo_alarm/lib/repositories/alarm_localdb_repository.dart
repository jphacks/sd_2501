import 'dart:convert';
import 'model/alarm_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../generated/repositories/alarm_localdb_repository.g.dart';

@riverpod
class AlarmLocalDBRepository extends _$AlarmLocalDBRepository {
  @override
  AlarmLocalDBRepositoryImpl build() {
    return AlarmLocalDBRepositoryImpl();
  }
}

///aaaaa
class AlarmLocalDBRepositoryImpl {
  Future<void> saveAlarm(AlarmModel alarm) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('alarm', jsonEncode(alarm.toJson()));
  }

  Future<AlarmModel?> getAlarm() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmJson = prefs.getString('alarm');
    if (alarmJson != null) {
      return AlarmModel.fromJson(jsonDecode(alarmJson));
    }

    print("repositories/alarm_localdb_repository.dart: No alarm data found");
    return null;
  }

  Future<void> setDateTime(DateTime dateTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('alarmDateTime', dateTime.toIso8601String());
  }

  /// カウントダウン秒数を保存
  Future<void> setCountdownSeconds(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('countdown_seconds', seconds);
  }

  /// カウントダウン秒数を取得
  Future<int?> getCountdownSeconds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('countdown_seconds');
  }

  /// カウントダウンモードかどうかを保存
  Future<void> setIsCountdownMode(bool isCountdown) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_countdown_mode', isCountdown);
  }

  /// カウントダウンモードかどうかを取得
  Future<bool> getIsCountdownMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_countdown_mode') ?? false;
  }
}
