import 'package:openai_loving_chatbot/dto/contact_dto.dart';
import 'package:openai_loving_chatbot/models/contact_model.dart';

import '../helpers/database_helper.dart';

class ContactDao {
  static Future<void> insert(ContactModel contact) async {
    await DbHelper.insert(DbHelper.chatsTable, contact.toJson());
  }

  static Future<List<ContactDto>> getAll() async {
    List<Map<String, Object?>> result = await DbHelper.get(
      DbHelper.contactsTable,
    );
    return List.generate(result.length, (i) {
      return ContactDto.fromJson(result[i]);
    });
  }
}

