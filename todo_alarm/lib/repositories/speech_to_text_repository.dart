import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

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

  Future<void> initialize() async {
    await _speechToText.initialize();
  }

  Future<String?> listen() async {
    return await _speechToText.listen(onResult: _onSpeechResult);
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    _lastRecognizedWords = result.recognizedWords;
  }

  Future<void> stop() async {
    await _speechToText.stop();
  }
}
