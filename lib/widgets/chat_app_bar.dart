import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String imagePath;
  const ChatAppBar({super.key, required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      title: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundImage: Image.asset(
              imagePath,
            ).image,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              title,
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
