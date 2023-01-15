import 'package:flutter/material.dart';
import 'package:openai_loving_chatbot/dto/message.dart';
import 'package:openai_loving_chatbot/widgets/message_box.dart';

import 'send_text_field.dart';

class ChatBody extends StatelessWidget {
  final ScrollController scrollController;
  final List<Message> messages;
  final TextEditingController editingController;
  final void Function() onPressed;
  const ChatBody(
      {super.key,
      required this.scrollController,
      required this.messages,
      required this.editingController,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 190,
            child: ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                return MessageBox(message: messages[index]);
              },
            ),
          ),
          SendTextField(
              onPressed: onPressed, editingController: editingController)
        ],
      ),
    );
  }
}
