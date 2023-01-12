import 'package:flutter/material.dart';
import 'package:openai_loving_chatbot/routes/chat_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatbot',
      theme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const ChatRoute(),
    );
  }

}
