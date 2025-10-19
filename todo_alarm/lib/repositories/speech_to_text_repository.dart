import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:uuid/uuid.dart';
import 'model/voice_model.dart';
import 'model/todo_item_model.dart';

part '../generated/repositories/speech_to_text_repository.g.dart';

@riverpod
class SpeechToTextRepository extends _$SpeechToTextRepository {
  @override
  SpeechToTextRepositoryImpl build() {
    return SpeechToTextRepositoryImpl();
  }
}

class SpeechToTextRepositoryImpl {
  final SpeechToText _speechToText = SpeechToText();
  String? _lastRecognizedWords;
  String? get lastRecognizedWords => _lastRecognizedWords;
  
  bool _isListening = false;
  bool get isListening => _isListening;

  // マッチング閾値（70%以上の一致率で一致と判定）
  static const double _matchThreshold = 0.7;

  // 初期化
  Future<bool> initialize() async {
    return await _speechToText.initialize(
      onStatus: (status) => print('Speech recognition status: $status'),
      onError: (error) => print('Speech recognition error: $error'),
    );
  }

  // リスニング開始
  Future<void> startListening({
    required Function(String) onResult,
  }) async {
    if (!_speechToText.isAvailable) {
      await initialize();
    }
    
    _isListening = true;
    await _speechToText.listen(
      onResult: (result) {
        _onSpeechResult(result);
        if (result.finalResult && _lastRecognizedWords != null) {
          onResult(_lastRecognizedWords!);
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      localeId: 'ja_JP', // 日本語対応
    );
  }

  // リスニング停止
  Future<void> stopListening() async {
    _isListening = false;
    await _speechToText.stop();
  }

  // 音声認識結果の処理
  void _onSpeechResult(SpeechRecognitionResult result) {
    _lastRecognizedWords = result.recognizedWords;
  }

  // VoiceModelを生成
  VoiceModel createVoiceRecord({
    required String recognizedText,
    String? matchedTodoId,
  }) {
    return VoiceModel(
      id: const Uuid().v4(),
      recognizedText: recognizedText,
      recordedAt: DateTime.now(),
      isMatched: matchedTodoId != null,
      matchedTodoId: matchedTodoId,
    );
  }

  // Todoタイトルとのマッチング判定（改善版）
  String? matchWithTodo({
    required String recognizedText,
    required List<TodoItemModel> todos,
  }) {
    if (todos.isEmpty) return null;
    
    final normalizedRecognized = _normalizeText(recognizedText);
    
    // 一致率が最も高いTodoを探す
    TodoItemModel? bestMatch;
    double bestMatchRatio = 0.0;
    
    for (final todo in todos) {
      final normalizedTitle = _normalizeText(todo.title);
      
      // 1. 完全一致チェック（最優先）
      if (normalizedRecognized == normalizedTitle) {
        return todo.id;
      }
      
      // 2. 部分一致チェック（次点）
      if (normalizedRecognized.contains(normalizedTitle) ||
          normalizedTitle.contains(normalizedRecognized)) {
        // 短い方の文字列長に対する一致度を計算
        final matchRatio = _calculateContainmentRatio(normalizedTitle, normalizedRecognized);
        if (matchRatio > bestMatchRatio) {
          bestMatchRatio = matchRatio;
          bestMatch = todo;
        }
        continue;
      }
      
      // 3. 文字単位の一致率チェック（最後の手段）
      final simpleMatchRatio = _calculateSimpleMatchRatio(normalizedTitle, normalizedRecognized);
      if (simpleMatchRatio > bestMatchRatio) {
        bestMatchRatio = simpleMatchRatio;
        bestMatch = todo;
      }
    }
    
    // 閾値以上の一致率があれば、そのTodoを返す
    if (bestMatchRatio >= _matchThreshold && bestMatch != null) {
      return bestMatch.id;
    }
    
    return null;
  }

  // テキストの正規化
  String _normalizeText(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[.,!?;:。、！？：\s]+'), '')
        .trim();
  }

  /// 部分一致時の一致率を計算
  /// 短い方の文字列が長い方にどれだけ含まれているかを基準にする
  double _calculateContainmentRatio(String shorter, String longer) {
    if (shorter.length > longer.length) {
      final temp = shorter;
      shorter = longer;
      longer = temp;
    }
    
    // 短い方が完全に含まれていれば高い評価
    if (longer.contains(shorter)) {
      return 0.9; // 完全一致ではないが、非常に高い一致率
    }
    
    return shorter.length / longer.length;
  }

  /// 友人作成の文字単位一致率計算（位置ベース）
  double _calculateSimpleMatchRatio(String text1, String text2) {
    if (text1.isEmpty && text2.isEmpty) return 1.0;
    if (text1.isEmpty || text2.isEmpty) return 0.0;

    final maxLength = text1.length < text2.length ? text1.length : text2.length;
    int matchCount = 0;

    for (int i = 0; i < maxLength; i++) {
      if (text1[i] == text2[i]) {
        matchCount++;
      }
    }

    return matchCount / maxLength;
  }

  // 利用可能かチェック
  bool get isAvailable => _speechToText.isAvailable;
}
