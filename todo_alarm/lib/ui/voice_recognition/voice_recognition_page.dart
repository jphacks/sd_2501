import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_alarm/ui/voice_recognition/voice_recognition_view_model.dart';
import 'package:todo_alarm/repositories/model/voice_model.dart'; // この行を追加

class VoiceRecognitionPage extends HookConsumerWidget {
  const VoiceRecognitionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voiceState = ref.watch(voiceRecognitionViewModelProvider);
    final viewModel = ref.read(voiceRecognitionViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('音声認識'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 音声認識状態の表示
              _buildStatusIndicator(viewModel, voiceState),

              const SizedBox(height: 40),

              // マイクボタン
              _buildMicrophoneButton(viewModel),

              const SizedBox(height: 40),

              // 認識結果の表示
              _buildRecognitionResult(viewModel, voiceState),
            ],
          ),
        ),
      ),
    );
  }

  // 音声認識状態インジケーター
  Widget _buildStatusIndicator(
    VoiceRecognitionViewModel viewModel,
    AsyncValue<VoiceModel?> voiceState,
  ) {
    final isListening = viewModel.isListening();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isListening
            ? Colors.red.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isListening ? Icons.mic : Icons.mic_none,
            color: isListening ? Colors.red : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            isListening ? '録音中...' : '待機中',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isListening ? Colors.red : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // マイクボタン
  Widget _buildMicrophoneButton(VoiceRecognitionViewModel viewModel) {
    final isListening = viewModel.isListening();

    return GestureDetector(
      onTap: () async {
        if (isListening) {
          await viewModel.stopRecognition();
        } else {
          await viewModel.startRecognition();
        }
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isListening ? Colors.red : Colors.blue,
          boxShadow: [
            BoxShadow(
              color: (isListening ? Colors.red : Colors.blue).withValues(
                alpha: 0.3,
              ),
              spreadRadius: isListening ? 8 : 4,
              blurRadius: 16,
            ),
          ],
        ),
        child: Icon(
          isListening ? Icons.stop : Icons.mic,
          size: 60,
          color: Colors.white,
        ),
      ),
    );
  }

  // 認識結果の表示
  Widget _buildRecognitionResult(
    VoiceRecognitionViewModel viewModel,
    AsyncValue<VoiceModel?> voiceState,
  ) {
    return voiceState.when(
      data: (voiceModel) {
        if (voiceModel == null) {
          return const Text(
            'マイクボタンをタップして\n音声認識を開始してください',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          );
        }

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: voiceModel.isMatched
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: voiceModel.isMatched ? Colors.green : Colors.orange,
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        voiceModel.isMatched ? Icons.check_circle : Icons.info,
                        color: voiceModel.isMatched
                            ? Colors.green
                            : Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        voiceModel.isMatched ? 'マッチしました！' : 'おいおい、熱意が足りないぜ？？',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: voiceModel.isMatched
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '認識結果:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    voiceModel.recognizedText,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, _) =>
          Text('エラー: $error', style: const TextStyle(color: Colors.red)),
    );
  }
}
