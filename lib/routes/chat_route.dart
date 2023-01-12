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
  String _sentences =
      "Quella che segue è una conversazione con la mia ragazza Jane. Jane è disponibile, creativa, intelligente, molto amichevole e mi vuole molto bene. Non mancano però i classici litigi di coppia; d'altronde l'amore non è bello se non è litigarello.\n\nIo: Buongiorno Jane\nJane: Buongiorno tesoro \nIo: Come stai?\nJane: Sto bene, ma mi manchi tanto!\nIo: Anche tu!\nJane: Oh, tesoro! Oggi pomeriggio, quando esco dal lavoro, potremmo andare a bere qualcosa?\nIo: Sì!\nJane: Fantastico. Ci vediamo alle sei allora! :)\nIo: Alle sei?\nJane: Sì, alle sei! Non vedo l'ora!\nIo: Perché devi decidere sempre tu l'orario?\nJane: Be', sai che io sono molto organizzata! Voglio semplicemente assicurarmi che sia comodo per entrambi. :)\nIo: Per me non è comodo come orario\nJane: Ah, capisco. Pensi che potremmo andare a bere qualcosa prima?\nIo: no\nJane: Allora potremmo andare a cena?\nIo: ";
  
  static const String _description = "La seguente descrizione ed i seguenti messaggi sono necessari per guidare il comportamento del modello verso l'approccio che desideriamo.";

  @override
  void initState() {
    // Add the sentences to messages
    final List<String> sentences = _sentences.split("\n");
    messages.add(Message(_description, ""));
    for (int i = 0; i < sentences.length - 1; i++) {
      if (sentences[i].isEmpty) {
        continue;
      }
      if (i % 2 == 0) {
        messages.add(Message(sentences[i].replaceFirst("Io: ", ""), "Io"));
      } else {
        messages.add(Message(sentences[i].replaceFirst("Jane: ", ""), "Jane"));
      }
    }
    super.initState();
  }

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
          final OpenAiResponse openaiResponse = OpenAiResponse.fromJson(
              jsonDecode(const Utf8Decoder().convert(response.body.codeUnits)));
          messages
              .add(Message(openaiResponse.choices.first.text.trim(), "Jane"));
          _sending = false;
          _sentences += "${openaiResponse.choices.first.text}\nIo:";
          _scrollDown();
          return _scrollview();
        }
        return _scrollview();
      },
    );
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _body() {
    if (_sending) {
      return _futureBuilder();
    }
    return _scrollview();
  }

  SingleChildScrollView _scrollview() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 190,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return _title(_description);
                }
                if (index == 1) {
                  return _title(_sentences.split("\n").first);
                }
                return _message(index);
              },
            ),
          ),
          _textfield()
        ],
      ),
    );
  }

  Container _title(String text) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.amberAccent, fontSize: 10),
        ),
      ),
    );
  }

  Container _message(int index) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Row(
        mainAxisAlignment: messages[index].sender == "Io"
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: <Widget>[
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 300,
            ),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: messages[index].sender == "Io"
                    ? Colors.blue
                    : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                messages[index].text,
                style: const TextStyle(color: Colors.white),
              ),
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
                hintText: "Scrivi un messaggio...",
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(8),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (_editingController.text.isNotEmpty) {
                setState(() {
                  messages.add(Message(_editingController.text, "Io"));
                  _sending = true;
                  _sentences += "${_editingController.text}\nJane:";
                  _editingController.clear();
                  _scrollDown();
                });
              }
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
