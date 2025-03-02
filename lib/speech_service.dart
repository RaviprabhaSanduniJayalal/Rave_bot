import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  Future<bool> init() async {
    return await _speechToText.initialize();
  }

  void startListening(Function(String) onResult) async {
    await _speechToText.listen(
      onResult: (result) {
        if (result.recognizedWords.isNotEmpty) {
          onResult(result.recognizedWords);
        }
      },
    );
  }

  void stopListening() async {
    await _speechToText.stop();
  }
}