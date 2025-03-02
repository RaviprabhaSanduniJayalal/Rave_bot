import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'ai_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  late AIService _aiService;

  String _conversation = 'Rave: Hi! How can I help you practice English today?';
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _aiService = AIService();
    _initializeTTS();
  }

  void _initializeTTS() {
    _flutterTts.setLanguage("en-US");
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) async {
          String userInput = result.recognizedWords;
          if (userInput.isNotEmpty) {
            await _processUserInput(userInput);
          }
        },
      );
    } else {
      setState(() {
        _conversation += '\nError: Speech recognition not available';
      });
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  Future<void> _processUserInput(String userInput) async {
    setState(() {
      _conversation += '\nYou: $userInput';
    });

    try {
      String aiResponse = await _aiService.getAIResponse(userInput);  // Pass only userInput
      // Check if the response is relevant
      if (aiResponse.toLowerCase().contains(userInput.toLowerCase())) {
        setState(() {
          _conversation += '\nRave: $aiResponse';
        });
        await _flutterTts.speak(aiResponse);
      } else {
        setState(() {
          _conversation += '\nRave: I’m not sure how to respond to that.';
        });
        await _flutterTts.speak("I’m not sure how to respond to that.");
      }
    } catch (e) {
      setState(() {
        _conversation += '\nError: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Rave Bot')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  child: Text(_conversation, style: TextStyle(fontSize: 18)),
                ),
              ),
              ElevatedButton(
                onPressed: _isListening ? _stopListening : _startListening,
                child: Text(_isListening ? 'Stop Listening' : 'Start Speaking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}