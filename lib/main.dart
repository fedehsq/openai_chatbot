import 'package:flutter/material.dart';
import 'package:openai_chatbot/helpers/database_helper.dart';
import 'package:openai_chatbot/routes/chats.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.init();
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
      home: const Chats(),
    );
  }
}
