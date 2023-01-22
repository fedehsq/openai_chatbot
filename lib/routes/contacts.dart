import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:openai_loving_chatbot/dao/contact_dao.dart';
import 'package:openai_loving_chatbot/routes/chat.dart';
import 'package:openai_loving_chatbot/routes/training.dart';

import '../dto/contact_dto.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<ContactDto>? _contacts;

  FutureBuilder<List<Object>> _get(
      Future<List<Object>>? future, Function onSuccess) {
    return FutureBuilder<List<Object>>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<List<Object>> snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          onSuccess(snapshot.data);
          return _body();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _getContacts() {
    return _get(ContactDao.getAll(), (data) {
      _contacts = data as List<ContactDto>;
    });
  }

  ListView _contactsList() {
    return ListView.builder(
      itemCount: _contacts!.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: CircleAvatar(
                radius: 30,
                backgroundImage:
                    MemoryImage(base64Decode(_contacts![index].photo))),
            title: Text(_contacts![index].name),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(contact: _contacts![index])),
              );
            },
          ),
        );
      },
    );
  }

  Future<String?> _botNameDialog() async {
    final TextEditingController controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bot name'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
                hintText: "Enter bot's name",
                errorText:
                    controller.text.isEmpty ? "Name can't be empty" : null),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  Navigator.of(context).pop(controller.text);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chats'),
        ),
        body: _body(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final String? botName = await _botNameDialog();
            if (botName != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BotTraining(
                              botName: botName,
                            )));
              });
            }
          },
          child: const Icon(Icons.add),
        ));
  }

  Widget _body() {
    if (_contacts == null) {
      return _getContacts();
    } else {
      return _contactsList();
    }
  }
}
