import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:openai_loving_chatbot/openai/completion_api.dart';

class SendFutureBuilder extends StatelessWidget {
  final String sentences;
  final void Function(AsyncSnapshot<dynamic>) onSuccess;
  final Widget Function() defaultReturn;
  const SendFutureBuilder(
      {super.key,
      required this.sentences,
      required this.onSuccess,
      required this.defaultReturn});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CompletionApi.sendMessage(sentences),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          onSuccess(snapshot);
        }
        return defaultReturn();
      },
    );
  }
}
