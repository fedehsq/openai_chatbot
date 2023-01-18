import 'package:openai_loving_chatbot/dto/contact_dto.dart';
import 'package:openai_loving_chatbot/dto/message_dto.dart';
import 'package:openai_loving_chatbot/models/message_model.dart';
import 'package:sqflite/sqflite.dart';

import '../helpers/database_helper.dart';

class MessageDao {
  static Future<void> insert(MessageModel message) async {
    await DbHelper.insert(DbHelper.chatsTable, message.toJson());
  }

  /// Get all last messages from each contact
  static Future<List<MessageDto>> getLastMessages(
      List<ContactDto> contacts) async {
    List<MessageDto> messages = [];
    for (ContactDto contact in contacts) {
      List<Map<String, Object?>> result = await DbHelper.get(
        DbHelper.chatsTable,
        where: "contact_id = ?",
        whereArgs: [contact.id],
      );
      if (result.isNotEmpty) {
        messages.add(MessageDto.fromModel(MessageModel.fromJson(result.last)));
      }
    }
    return messages;
  }

  /// Get all messages from contact
  static Future<List<MessageDto>> getMessages(ContactDto contact) async {
    List<Map<String, Object?>> result = await DbHelper.get(
      DbHelper.chatsTable,
      where: "contact_id = ?",
      whereArgs: [contact.id],
    );
    return List.generate(result.length, (i) {
      return MessageDto.fromModel(MessageModel.fromJson(result[i]));
    });
  }
}
