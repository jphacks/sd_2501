import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_alarm/ui/alarm_display/alarm_display_view_model.dart';

class AlarmDisplay extends HookConsumerWidget {
  const AlarmDisplay({super.key});

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString();
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTime = useState(const TimeOfDay(hour: 6, minute: 30));
    final countdownSeconds = useState<int>(3);
    final isCountdownMode = useState(false);
    final remainingSeconds = useState<int?>(null);

    // カウントダウンモードの初期化
    useEffect(() {
      Future.microtask(() async {
        final isCountdown = await ref
            .read(alarmDisplayViewModelProvider.notifier)
            .isCountdownMode();
        isCountdownMode.value = isCountdown;
      });
      return null;
    }, []);

    // 残り時間を定期的に更新
    useEffect(() {
      Timer? timer;
      if (isCountdownMode.value) {
        timer = Timer.periodic(const Duration(seconds: 1), (_) {
          final remaining = ref
              .read(alarmDisplayViewModelProvider.notifier)
              .getRemainingSeconds();
          remainingSeconds.value = remaining;
        });
      }
      return timer?.cancel;
    }, [isCountdownMode.value]);

    Future<void> selectTime() async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime.value,
      );
      if (picked != null && picked != selectedTime.value) {
        selectedTime.value = picked;
        ref
            .read(alarmDisplayViewModelProvider.notifier)
            .updateAlarmTime(picked);
      }
    }

    Future<void> startCountdown() async {
      await ref
          .read(alarmDisplayViewModelProvider.notifier)
          .setCountdownAlarm(countdownSeconds.value);
    }

    Future<void> cancelCountdown() async {
      await ref
          .read(alarmDisplayViewModelProvider.notifier)
          .cancelCountdown();
      isCountdownMode.value = false;
      remainingSeconds.value = null;
    }

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          // モード切り替えスイッチ
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('時刻指定'),
              Switch(
                value: isCountdownMode.value,
                onChanged: (value) {
                  isCountdownMode.value = value;
                  if (!value) {
                    cancelCountdown();
                  }
                },
              ),
              const Text('カウントダウン'),
            ],
          ),
          
          const SizedBox(height: 16),

          // カウントダウンモード or 時刻指定モード
          if (isCountdownMode.value)
            // カウントダウンモードUI
            Column(
              children: [
                // 秒数選択
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: remainingSeconds.value == null || remainingSeconds.value == 0
                          ? () {
                              if (countdownSeconds.value > 1) {
                                countdownSeconds.value--;
                              }
                            }
                          : null,
                    ),
                    Container(
                      width: 150,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.indigo.withValues(alpha: 0.1),
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${countdownSeconds.value}秒',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: remainingSeconds.value == null || remainingSeconds.value == 0
                          ? () {
                              if (countdownSeconds.value < 60) {
                                countdownSeconds.value++;
                              }
                            }
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // 残り時間表示と開始/キャンセルボタン
                if (remainingSeconds.value != null && remainingSeconds.value! > 0) ...[
                  Text(
                    '残り: ${remainingSeconds.value}秒',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: cancelCountdown,
                    icon: const Icon(Icons.stop),
                    label: const Text('キャンセル'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ] else ...[
                  ElevatedButton.icon(
                    onPressed: startCountdown,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('開始'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ],
            )
          else
            // 時刻指定モードUI（既存）
            GestureDetector(
              onTap: selectTime,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.indigo.withValues(alpha: 0.1),
                    width: 6,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SizedBox(
                  width: 300,
                  height: 150,
                  child: Center(
                    child: Text(
                      _formatTime(selectedTime.value),
                      style: const TextStyle(fontSize: 80),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
