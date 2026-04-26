import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey ='AIzaSyD5yKQBqEGkFHh-GFojzhmWIMKPfTHeVUI';
  static const String _baseUrl =
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  static Future<String> matchVolunteerToNeed({
    required String needDescription,
    required String needCategory,
    required String needLocation,
    required List<Map<String, dynamic>> volunteers,
  }) async {
    try {
      final prompt = '''
You are a volunteer matching system.
Need: $needCategory in $needLocation - $needDescription
Volunteers: ${volunteers.map((v) => '${v['name']} - ${v['skills']} - ${v['location']}').join(', ')}
Recommend the best volunteer in 2 sentences.
''';

      final uri = Uri.parse('$_baseUrl?key=$_apiKey');
      
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'role': 'user',
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 200,
          }
        }),
      ).timeout(const Duration(seconds: 30));

      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        print('Gemini error code: ${response.statusCode}');
        print('Gemini error body: ${response.body}');
        return 'Error ${response.statusCode}: ${response.body}';
      }
    } catch (e) {
      print('Error: $e');
      return 'Connection error: $e';
    }
  }
}