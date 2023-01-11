import 'package:http/http.dart' as http;
import 'package:openai_loving_chatbot/openai/api_key.dart';
import 'package:openai_loving_chatbot/openai/openai_request.dart';

class CompletionApi {
  static String completionApiUrl = 'https://api.openai.com/v1/completions';

  static Future<http.Response> _post(String url, Map<String, String> headers,
      Map<String, dynamic> body) async {
    return await http.post(Uri.parse(url), headers: headers, body: body);
  }

  static Future<http.Response> sendMessage(String message) async {
    return await _post(
        completionApiUrl,
        {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openaiApiKey',
        },
        OpenAiRequest(prompt: message).toJson());
  }
}
