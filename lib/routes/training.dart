import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:openai_chatbot/dao/contact_dao.dart';
import 'package:openai_chatbot/dao/message_dao.dart';
import 'package:openai_chatbot/dto/message_dto.dart';
import 'package:openai_chatbot/helpers/jane_avatar.dart';
import 'package:openai_chatbot/models/contact_model.dart';
import 'package:openai_chatbot/openai/image_geneation_response.dart';
import 'package:openai_chatbot/openai/image_generation_api.dart';
import 'package:openai_chatbot/routes/chat.dart';
import 'package:openai_chatbot/widgets/chat_body.dart';

import '../dto/contact_dto.dart';
import '../models/message_model.dart';

class BotTraining extends StatefulWidget {
  final String botName;
  const BotTraining({super.key, required this.botName});

  @override
  State<BotTraining> createState() => _BotTrainingState();
}

class _BotTrainingState extends State<BotTraining> {
  final TextEditingController _editingController = TextEditingController();
  bool _sending = false;
  final List<MessageDto> _messages = [];
  ContactDto? _contact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.botName),
          actions: [
            IconButton(
                onPressed: () {
                  if (_messages.length % 2 == 0 && _messages.isNotEmpty) {
                    // Show snackbar if no message has been sent
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Last message must be from the bot")));
                  } else {
                    setState(() {
                      _sending = true;
                    });
                  }
                },
                icon: const Icon(Icons.done))
          ],
        ),
        backgroundColor: Colors.black,
        body: _body());
  }

  Future<void> _showErrorDialog(String error) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(error),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"))
            ],
          );
        });
  }

  Future<void> _showInfoDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Info"),
            // Rich text with "jane" in bold clickable to open the training page
            content: RichText(
              text: TextSpan(
                text: "This chatbot can be 'trained' on the data you provide.\n"
                    "You can train it by gining them an identity and showing some example of messages (like ",
                children: <TextSpan>[
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          ContactDao.getByName("Jane").then((value) =>
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Chat(contact: value!))));
                        },
                      text: "Jane",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue)),
                  const TextSpan(
                      text: ").\n"
                          "The more you train it, the better it will get.\n"
                          "Without that instruction the bot might stray and mimic the human it's interacting with and become sarcastic or some other behavior we want to avoid.\n"
                          "Press on the icon in the top right corner to stop training."),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"))
            ],
          );
        });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _showInfoDialog();
    });
    super.initState();
  }

  Widget _body() {
    if (_sending) {
      return _create();
    } else {
      return ChatBody(
          messages: _messages,
          editingController: _editingController,
          onPressed: _send);
    }
  }

  FutureBuilder<void> _create() {
    return FutureBuilder<void>(
        future: _createBot(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showErrorDialog(snapshot.error.toString());
            });
            _sending = false;
            return _body();
          } else if (snapshot.connectionState == ConnectionState.done) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Chat(
                          contact: _contact!,
                        )),
              );
              if (mounted) {
                Navigator.pop(context);
              }
            });
            return Container();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Future<void> _createBot() async {
    bool trained = _messages.isNotEmpty;
    String avatar = janeAvatar;
    if (trained) {
      final Response response =
          await ImageGenerationApi.generateImage(_messages.first.text);
      if (response.statusCode != 200) {
        // Get the error message from the response
        String error = jsonDecode(response.body)["error"]["message"];
        // Raise futureBuilder error
        throw Exception(error);
      }
      ImageGenerationResponse imageGenerationResponse =
          ImageGenerationResponse.fromJson(jsonDecode(response.body));
      avatar = imageGenerationResponse.data.first.b64Json!;
    }
    ContactModel contact = ContactModel(widget.botName, avatar, trained);
    int id = await ContactDao.insert(contact);
    _contact = ContactDto(id, contact.name, contact.photo, contact.trained);
    for (MessageDto message in _messages) {
      MessageModel messageModel =
          MessageModel(message.text, id, message.sender == "Io" ? true : false);
      await MessageDao.insert(messageModel);
    }
  }

  void _send() {
    if (_editingController.text.isNotEmpty) {
      setState(() {
        if (_messages.length % 2 != 0 || _messages.isEmpty) {
          _messages.add(MessageDto(_editingController.text, "Io"));
        } else {
          _messages.add(MessageDto(_editingController.text, "Bot"));
        }
        _editingController.clear();
      });
    }
  }
}
