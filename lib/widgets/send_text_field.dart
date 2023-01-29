import 'package:flutter/material.dart';

class SendTextField extends StatelessWidget {
  final void Function() onPressed;
  final TextEditingController editingController;
  const SendTextField({
    super.key,
    required this.onPressed,
    required this.editingController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      color: Colors.grey.shade800,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              maxLines: null,
              controller: editingController,
              decoration: const InputDecoration(
                hintText: "Scrivi un messaggio...",
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(8),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
