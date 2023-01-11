import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:openai_loving_chatbot/entities/message.dart';
import 'package:openai_loving_chatbot/openai/completion_api.dart';
import 'package:openai_loving_chatbot/openai/openai_response.dart';

class ChatRoute extends StatefulWidget {
  const ChatRoute({super.key});

  @override
  State<ChatRoute> createState() => _ChatRouteState();
}

class _ChatRouteState extends State<ChatRoute> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _editingController = TextEditingController();
  bool _sending = false;
  final List<Message> messages = <Message>[];
  String _sentences = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(), backgroundColor: Colors.black, body: _body());
  }

  FutureBuilder _futureBuilder() {
    return FutureBuilder(
      future: CompletionApi.sendMessage(_sentences),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final Response response = snapshot.data;
          final OpenAiResponse openaiResponse =
              OpenAiResponse.fromJson(jsonDecode(response.body));
          messages.add(Message(openaiResponse.choices.first.text, "Jane"));
          _sending = false;
          _sentences += "${openaiResponse.choices.first.text}\n";
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
          return _listview();
        }
        return _listview();
      },
    );
  }

  Widget _body() {
    if (_sending) {
      return _futureBuilder();
    }
    return _listview();
  }

  SingleChildScrollView _listview() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 190,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                return _message(index);
              },
            ),
          ),
          _textfield()
        ],
      ),
    );
  }

  Container _message(int index) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Row(
        mainAxisAlignment: messages[index].sender == "You"
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: messages[index].sender == "You"
                  ? Colors.blue
                  : Colors.grey.shade800,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              messages[index].text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Container _textfield() {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      color: Colors.grey.shade800,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: null,
              controller: _editingController,
              decoration: const InputDecoration(
                hintText: "Type a message...",
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(8),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              setState(() {
                messages.add(Message(_editingController.text, "You"));
                _sending = true;
                _sentences += "${_editingController.text}\n";
                _editingController.clear();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                });
              });
            },
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      toolbarHeight: 100,
      title: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundImage: Image.asset(
              "images/jane.png",
            ).image,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Text(
              "Jane",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
