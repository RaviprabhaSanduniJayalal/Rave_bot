import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speechToText = SpeechToText();

  Future<bool> init() async {
    return await _speechToText.initialize();
  }

  void startListening(Function(String) onResult) async {
    await _speechToText.listen(onResult: (result) {
      onResult(result.recognizedWords);
    });
  }

  void stopListening() async {
    await _speechToText.stop();
  }
}
