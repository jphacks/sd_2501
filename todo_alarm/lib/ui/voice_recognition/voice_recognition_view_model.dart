import 'package:alarm/alarm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_alarm/repositories/speech_to_text_repository.dart';
import 'package:todo_alarm/repositories/model/voice_model.dart';
import 'package:todo_alarm/repositories/model/todo_status.dart'; // この行を追加
import 'package:todo_alarm/ui/todo_list/todo_list_view_model.dart';

part '../../generated/ui/voice_recognition/voice_recognition_view_model.g.dart';

@riverpod
class VoiceRecognitionViewModel extends _$VoiceRecognitionViewModel {
  @override
  Future<VoiceModel?> build() async {
    return null;
  }

  // 音声認識を開始
  Future<void> startRecognition() async {
    final repository = ref
        .read(speechToTextRepositoryProvider.notifier)
        .build();

    // 初期化
    final initialized = await repository.initialize();
    if (!initialized) {
      state = AsyncValue.error('音声認識を初期化できませんでした', StackTrace.current);
      return;
    }

    // リスニング開始
    await repository.startListening(
      onResult: (recognizedText) async {
        await _processRecognizedText(recognizedText);
      },
    );
  }

  // 音声認識を停止
  Future<void> stopRecognition() async {
    final repository = ref
        .read(speechToTextRepositoryProvider.notifier)
        .build();
    await repository.stopListening();
  }

  // 認識されたテキストを処理
  Future<void> _processRecognizedText(String recognizedText) async {
    print('📝 テキスト処理開始: $recognizedText');
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref
          .read(speechToTextRepositoryProvider.notifier)
          .build();
      final todos = await ref.read(todoListViewModelProvider.future);

      // 未完了と取り組み中のTodoを対象にマッチング
      final incompleteTodos = todos
          .where((todo) => todo.status != TodoStatus.completed)
          .toList();

      print('📋 未完了+取り組み中のTodo数: ${incompleteTodos.length}');

      // Todoとのマッチング
      final matchedTodoId = repository.matchWithTodo(
        recognizedText: recognizedText,
        todos: incompleteTodos,
      );

      print('🎯 マッチ結果: ${matchedTodoId != null ? "成功" : "おいおい、熱意が足りないぜ？？"}');

      // マッチした場合は該当Todoを「取り組み中」にする
      if (matchedTodoId != null) {
        print('✅ Todoを取り組み中にします: $matchedTodoId');
        await ref
            .read(todoListViewModelProvider.notifier)
            .markAsInProgress(matchedTodoId);

        await Alarm.stop(1);
      }

      // VoiceModelを作成して履歴として保存
      final voiceRecord = repository.createVoiceRecord(
        recognizedText: recognizedText,
        matchedTodoId: matchedTodoId,
      );

      return voiceRecord;
    });
  }

  // リスニング状態を取得
  bool isListening() {
    final repository = ref
        .read(speechToTextRepositoryProvider.notifier)
        .build();
    return repository.isListening;
  }

  // 最後に認識されたテキストを取得
  String? getLastRecognizedText() {
    final repository = ref
        .read(speechToTextRepositoryProvider.notifier)
        .build();
    return repository.lastRecognizedWords;
  }
}
