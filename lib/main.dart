import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  stt.SpeechToText _speech = stt.SpeechToText();
  FlutterTts _flutterTts = FlutterTts();

  String _text = 'Press the button and start speaking';
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _flutterTts.setLanguage("en-US"); // Set the language for bot's speech
  }

  // Start listening to the user's speech
  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(onResult: (result) {
        setState(() {
          _text = result.recognizedWords;
        });
        // Here, you can call a function to process the bot's response
        _botRespond(_text);
      });
    }
  }

  // Stop listening
  void _stopListening() {
    setState(() {
      _isListening = false;
    });
    _speech.stop();
  }

  // Bot's voice response function
  void _botRespond(String userInput) async {
    // Example: Bot responds based on the input
    String botResponse = "You said: $userInput";
    await _flutterTts.speak(botResponse);  // Bot speaks the response
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Speech Recognition & TTS')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_text, style: TextStyle(fontSize: 24)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isListening ? _stopListening : _startListening,
                child: Text(_isListening ? 'Stop Listening' : 'Start Listening'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
