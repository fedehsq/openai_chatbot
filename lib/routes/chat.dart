import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:openai_loving_chatbot/dao/message_dao.dart';
import 'package:openai_loving_chatbot/dto/contact_dto.dart';
import 'package:openai_loving_chatbot/dto/message_dto.dart';
import 'package:openai_loving_chatbot/helpers/helper.dart';
import 'package:openai_loving_chatbot/models/message_model.dart';
import 'package:openai_loving_chatbot/openai/openai_request.dart';
import 'package:openai_loving_chatbot/openai/openai_response.dart';
import 'package:openai_loving_chatbot/widgets/chat_app_bar.dart';
import 'package:openai_loving_chatbot/widgets/chat_body.dart';

import '../openai/completion_api.dart';

class Chat extends StatefulWidget {
  final ContactDto contact;
  final String peer;
  const Chat({super.key, required this.peer, required this.contact});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _editingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _sentences = "";
  bool _sending = false;
  List<MessageDto>? _messages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ChatAppBar(contact: widget.contact),
        backgroundColor: Colors.black,
        body: _body());
  }

  Widget _body() {
    if (_messages == null) {
      return _getMessages();
    } else if (_sending) {
      return _sendMessage();
    } else {
      return ChatBody(
          scrollController: _scrollController,
          messages: _messages!,
          editingController: _editingController,
          onPressed: _send);
    }
  }

  Widget _sendMessage() {
    return FutureBuilder(
      future: CompletionApi.sendMessage(_sentences),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          _onMessageReceive(snapshot.data);
        }
        return ChatBody(
            scrollController: _scrollController,
            messages: _messages!,
            editingController: _editingController,
            onPressed: _send);
      },
    );
  }

  void _onMessageReceive(Response response) {
    final OpenAiResponse openaiResponse = OpenAiResponse.fromJson(
        jsonDecode(const Utf8Decoder().convert(response.body.codeUnits)));
    String message = openaiResponse.choices.first.text.trim();
    _messages!.add(MessageDto(message, "Bot"));
    MessageDao.insert(MessageModel(message, widget.contact.id, false));
    _sending = false;
    _sentences += "${openaiResponse.choices.first.text}$stopword";
    Helper.scrollDown(_scrollController);
  }

  Widget _getMessages() {
    return FutureBuilder<List<MessageDto>>(
      future: MessageDao.getMessages(widget.contact),
      builder:
          (BuildContext context, AsyncSnapshot<List<MessageDto>> snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          _messages = snapshot.data;
          for (var element in _messages!) {
            if (element.sender == "Io") {
              print("${element.text} ${element.sender}");
              _sentences += "${element.text}$botStopword";
            } else {
              _sentences += "${element.text}$stopword";
            }
          }
          //print(_sentences);
          return _body();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void _send() {
    if (_editingController.text.isNotEmpty) {
      MessageModel messageModel =
          MessageModel(_editingController.text, widget.contact.id, true);
      MessageDao.insert(messageModel);
      setState(() {
        _messages!.add(MessageDto(_editingController.text, "Io"));
        _sending = true;
        _sentences += "${_editingController.text}$botStopword";
        _editingController.clear();
        Helper.scrollDown(_scrollController);
      });
    }
  }
}