import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:openai_loving_chatbot/dao/contact_dao.dart';
import 'package:openai_loving_chatbot/dao/message_dao.dart';
import 'package:openai_loving_chatbot/dto/message_dto.dart';
import 'package:openai_loving_chatbot/routes/chat.dart';

import '../dto/contact_dto.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  List<ContactDto>? _contacts;
  List<MessageDto>? _messages;

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

  Widget _getLastMessages() {
    return _get(MessageDao.getLastMessages(_contacts!), (data) {
      _messages = data as List<MessageDto>;
    });
  }

  ListView _contactsList() {
    return ListView.builder(
      itemCount: _contacts!.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: CircleAvatar(
              radius: 30,
              backgroundImage:
                  MemoryImage(base64Decode(_contacts![index].photo))),
          title: Text(_contacts![index].name),
          // Empty subtitle id the last message is null
          subtitle: _messages?[index].text != null
              ? Text(_messages![index].text)
              : const Text(''),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Chat(
                      peer: _contacts![index].name,
                      contact: _contacts![index])),
            );
          },
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
    );
  }

  Widget _body() {
    if (_contacts == null) {
      return _getContacts();
    } else if (_messages == null) {
      return _getLastMessages();
    } else {
      return _contactsList();
    }
  }
}
