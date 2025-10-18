import 'dart:convert' ;
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
    return null;
  }

  Future<void> setDateTime(DateTime dateTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('alarmDateTime', dateTime.toIso8601String());
  }
}