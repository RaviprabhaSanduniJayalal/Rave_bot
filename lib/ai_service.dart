import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  final String apiUrl = dotenv.env['API_URL'] ?? '';
  final String apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';

  AIService() {
    if (apiUrl.isEmpty || apiKey.isEmpty) {
      throw Exception('API_URL or OPENAI_API_KEY is not set in .env');
    }
  }

  Future<String> getAIResponse(String userInput) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'user', 'content': userInput}
          ],
          'max_tokens': 150,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        throw Exception('Failed to get AI response: ${response.body}');
      }
    } catch (e) {
      print('Error fetching AI response: $e');
      return 'Sorry, something went wrong!';
    }
  }
}
