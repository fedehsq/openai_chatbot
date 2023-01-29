import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:openai_chatbot/dao/message_dao.dart';
import 'package:openai_chatbot/dto/contact_dto.dart';
import 'package:openai_chatbot/dto/message_dto.dart';
import 'package:openai_chatbot/models/message_model.dart';
import 'package:openai_chatbot/openai/text_completion_request.dart';
import 'package:openai_chatbot/openai/text_completion_response.dart';
import 'package:openai_chatbot/widgets/chat_app_bar.dart';
import 'package:openai_chatbot/widgets/chat_body.dart';

import '../openai/text_completion_api.dart';

class Chat extends StatefulWidget {
  final ContactDto contact;
  const Chat({super.key, required this.contact});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _editingController = TextEditingController();
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
          messages: _messages!,
          editingController: _editingController,
          onPressed: _send);
    }
  }

  Widget _sendMessage() {
    return FutureBuilder(
      future: TextCompletionApi.sendMessage(_sentences),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          _onMessageReceive(snapshot.data);
        }
        return ChatBody(
            messages: _messages!,
            editingController: _editingController,
            onPressed: _send);
      },
    );
  }

  void _onMessageReceive(Response response) {
    final TextCompletionResponse openaiResponse =
        TextCompletionResponse.fromJson(
            jsonDecode(const Utf8Decoder().convert(response.body.codeUnits)));
    String message = openaiResponse.choices.first.text.trim();
    _messages!.add(MessageDto(message, "Bot"));
    MessageDao.insert(MessageModel(message, widget.contact.id, false));
    _sending = false;
    _sentences += "${openaiResponse.choices.first.text}$stopword";
    // Helper.scrollDown(_scrollController);
  }

  Widget _getMessages() {
    return FutureBuilder<List<MessageDto>>(
      future: MessageDao.getMessages(widget.contact),
      builder:
          (BuildContext context, AsyncSnapshot<List<MessageDto>> snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          _messages = snapshot.data;
          int startChatIndex = 0;
          if (widget.contact.trained) {
            _sentences += "${_messages!.first.text}\nIo:";
            startChatIndex = 1;
          }
          for (int i = startChatIndex; i < _messages!.length; i++) {
            if (_messages![i].sender == "Io") {
              _sentences += "${_messages![i].text}$botStopword";
            } else {
              _sentences += "${_messages![i].text}$stopword";
            }
          }
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   if (_messages!.isNotEmpty) {
          //     Helper.scrollDown(_scrollController);
          //   }
          // });
          // _messages = snapshot.data?.reversed.toList();
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
        // Helper.scrollDown(_scrollController);
      });
    }
  }
}
