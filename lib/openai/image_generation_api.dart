import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:openai_chatbot/openai/api_key.dart';
import 'package:openai_chatbot/openai/image_generation_request.dart';
import 'package:openai_chatbot/openai/text_completion_request.dart';

class ImageGenerationApi {
  static String imageGenerationApiUrl =
      'https://api.openai.com/v1/images/generations';

  static Future<http.Response> _post(
      String url, Map<String, String> headers, String body) async {
    return await http.post(Uri.parse(imageGenerationApiUrl),
        headers: headers, body: body);
  }

  static Future<http.Response> generateImage(String prompt) async {
    return await _post(
        imageGenerationApiUrl,
        {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $openaiApiKey',
        },
        jsonEncode(ImageGenerationRequest(prompt)));
  }
}
