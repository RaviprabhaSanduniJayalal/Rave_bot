import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  final String apiUrl = dotenv.env['HUGGINGFACE_API_URL'] ?? '';
  final String apiKey = dotenv.env['HUGGINGFACE_API_KEY'] ?? '';

  Future<String> getAIResponse(String userInput) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'inputs': userInput,  // Only pass user input
          'parameters': {
            'max_length': 50,  // Shorter responses
            'temperature': 0.5,  // Less randomness
            'top_p': 0.8,  // Focus on more likely words
            'repetition_penalty': 1.5,  // Avoid repetition
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty && data[0]['generated_text'] != null) {
          String aiResponse = data[0]['generated_text'];
          // Clean the response
          aiResponse = cleanResponse(aiResponse);
          return aiResponse;
        } else {
          return 'Hmm, I’m not sure how to respond to that.';
        }
      } else {
        throw Exception('Failed to get AI response: ${response.body}');
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  String cleanResponse(String aiResponse) {
    // Take only the first sentence
    aiResponse = aiResponse.split('.')[0];
    aiResponse = aiResponse.trim();  // Trim whitespace
    return aiResponse;
  }
}