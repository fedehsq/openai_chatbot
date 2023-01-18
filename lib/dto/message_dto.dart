import '../models/message_model.dart';

class MessageDto {
  final int? id;
  final String text;
  final String sender;

  MessageDto(this.text, this.sender, {this.id});

  factory MessageDto.fromModel(MessageModel messageModel) {
    return MessageDto(
      messageModel.text,
      messageModel.sent ? 'Io' : 'Bot',
      id: messageModel.id,
    );
  }
}
