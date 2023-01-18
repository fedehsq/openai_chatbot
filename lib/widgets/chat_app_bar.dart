import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:openai_loving_chatbot/dto/contact_dto.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ContactDto contact;
  const ChatAppBar({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      title: Column(
        children: [
          CircleAvatar(
              radius: 32,
              backgroundImage: MemoryImage(base64Decode(contact.photo))),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              contact.name,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
