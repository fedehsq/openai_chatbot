import 'package:flutter/material.dart';
import 'package:openai_loving_chatbot/dto/message.dart';

class MessageBox extends StatelessWidget {
  final Message message;

  const MessageBox({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Row(
        mainAxisAlignment:
            message.sender == "Io" ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 300,
            ),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: message.sender == "Io" ? Colors.blue : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                message.text,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
