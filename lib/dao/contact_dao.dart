import 'package:openai_loving_chatbot/dto/contact_dto.dart';
import 'package:openai_loving_chatbot/models/contact_model.dart';

import '../helpers/database_helper.dart';

class ContactDao {
  static Future<int> insert(ContactModel contact) async {
    return await DbHelper.insert(DbHelper.contactsTable, contact.toJson());
  }

  static Future<List<ContactDto>> getAll() async {
    List<Map<String, Object?>> result = await DbHelper.get(
      DbHelper.contactsTable,
    );
    return List.generate(result.length, (i) {
      return ContactDto.fromJson(result[i]);
    });
  }

  static Future<List<ContactDto>> getAllWithAtLeastOneMessage() async {
    List<Map<String, Object?>> result = await DbHelper.get(
      DbHelper.contactsTable,
      where: "id IN (SELECT DISTINCT contact_id FROM chats)",
    );
    return List.generate(result.length, (i) {
      return ContactDto.fromJson(result[i]);
    });
  }

  static Future<ContactDto?> getByName(String name) async {
    List<Map<String, Object?>> result = await DbHelper.get(
      DbHelper.contactsTable,
      where: "name = ?",
      whereArgs: [name],
    );
    if (result.isNotEmpty) {
      return ContactDto.fromJson(result[0]);
    }
    return null;
  }
}

