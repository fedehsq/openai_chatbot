import 'package:flutter/material.dart';

class Helper {
  static void scrollDown(ScrollController controller) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('scrollDown');
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }
}
