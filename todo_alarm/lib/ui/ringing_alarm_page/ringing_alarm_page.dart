import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';

class RingingAlarmPage extends StatelessWidget {
  final AlarmSettings alarmSettings;

  const RingingAlarmPage({super.key, required this.alarmSettings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[900],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // アラームアイコン
              Icon(Icons.alarm, size: 120, color: Colors.white),
              SizedBox(height: 32),

              // アラーム時刻
              Text(
                'アラーム',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '${alarmSettings.dateTime.hour.toString().padLeft(2, '0')}:${alarmSettings.dateTime.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 72,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 64),
              // 停止ボタン
              // このボタンで停止
              ElevatedButton(
                onPressed: () async {
                  await Alarm.stop(1);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red[900],
                  padding: EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  '停止',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
