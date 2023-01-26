import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:openai_loving_chatbot/openai/api_key.dart';
import 'package:openai_loving_chatbot/openai/text_completion_request.dart';

class TextCompletionApi {
  static String completionApiUrl = 'https://api.openai.com/v1/completions';

  static Future<http.Response> _post(
      String url, Map<String, String> headers, String body) async {
    return await http.post(Uri.parse(completionApiUrl),
        headers: headers, body: body);
  }

  static Future<http.Response> sendMessage(String message) async {
    print(message);
    return await _post(
        completionApiUrl,
        {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $openaiApiKey',
        },
        jsonEncode(TextCompletionRequest(prompt: message)));
  }
}
