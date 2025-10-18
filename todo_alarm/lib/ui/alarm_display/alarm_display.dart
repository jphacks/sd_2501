import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

    Future<void> selectTime() async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime.value,
      );
      if (picked != null && picked != selectedTime.value) {
        selectedTime.value = picked;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: GestureDetector(
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
    );
  }
}
