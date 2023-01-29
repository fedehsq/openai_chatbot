import 'package:flutter/material.dart';
import 'package:openai_chatbot/dto/message_dto.dart';
import 'package:openai_chatbot/widgets/message_box.dart';

import 'send_text_field.dart';


class ChatBody extends StatelessWidget {
  final List<MessageDto> messages;
  final TextEditingController editingController;
  final void Function() onPressed;
  static final GlobalKey<FormState> _key = GlobalKey<FormState>();
  const ChatBody(
      {super.key,
      required this.messages,
      required this.editingController,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: _key,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
              return MessageBox(message: messages[messages.length - 1 - index]);
            },
          ),
        ),
        SendTextField(
            onPressed: onPressed, editingController: editingController)
      ],
    );
  }
}