import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:openai_loving_chatbot/dto/message.dart';
import 'package:openai_loving_chatbot/helpers/helper.dart';
import 'package:openai_loving_chatbot/openai/openai_request.dart';
import 'package:openai_loving_chatbot/openai/openai_response.dart';
import 'package:openai_loving_chatbot/widgets/chat_app_bar.dart';
import 'package:openai_loving_chatbot/widgets/chat_body.dart';
import 'package:openai_loving_chatbot/widgets/send_future_builder.dart';

class ChatRoute extends StatefulWidget {
  final bool? example;
  final String peer;
  const ChatRoute({super.key, required this.peer, this.example});

  @override
  State<ChatRoute> createState() => _ChatRouteState();
}

class _ChatRouteState extends State<ChatRoute> {
  String _sentences = "";
  bool _sending = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _editingController = TextEditingController();
  final List<Message> messages = <Message>[];

  @override
  void initState() {
    if (widget.example != null) {
      _sentences = training;
      // Add the sentences to messages
      final List<String> sentences = training.split("\n");
      messages.add(Message(trainingDescription));
      for (int i = 0; i < sentences.length - 1; i++) {
        if (sentences[i].isEmpty) {
          continue;
        }
        if (i % 2 == 0) {
          messages.add(
              Message(sentences[i].replaceFirst("Io: ", ""), sender: "Io"));
        } else {
          messages.add(Message(sentences[i].replaceFirst("Bot: ", "")));
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ChatAppBar(title: widget.peer, imagePath: "images/jane.png"),
        backgroundColor: Colors.black,
        body: _sending
            ? SendFutureBuilder(
                sentences: _sentences,
                onSuccess: _onSuccess,
                defaultReturn: _defaultReturn)
            : ChatBody(
                scrollController: _scrollController,
                messages: messages,
                editingController: _editingController,
                onPressed: _send));
  }

  ChatBody _defaultReturn() {
    return ChatBody(
        scrollController: _scrollController,
        messages: messages,
        editingController: _editingController,
        onPressed: _send);
  }

  void _onSuccess(AsyncSnapshot<dynamic> snapshot) {
    final Response response = snapshot.data;
    final OpenAiResponse openaiResponse = OpenAiResponse.fromJson(
        jsonDecode(const Utf8Decoder().convert(response.body.codeUnits)));
    messages.add(Message(openaiResponse.choices.first.text.trim()));
    _sending = false;
    _sentences += "${openaiResponse.choices.first.text}$stopword";
    Helper.scrollDown(_scrollController);
  }

  void _send() {
    if (_editingController.text.isNotEmpty) {
      setState(() {
        messages.add(Message(_editingController.text, sender: "Io"));
        _sending = true;
        _sentences += "${_editingController.text}$botStopword";
        _editingController.clear();
        Helper.scrollDown(_scrollController);
      });
    }
  }
}
