import 'package:openai_loving_chatbot/helpers/jane_avatar.dart';
import 'package:openai_loving_chatbot/models/message_model.dart';
import 'package:openai_loving_chatbot/openai/openai_request.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static const String database = "chat.db";
  static const int databaseVersion = 1;
  static const String chatsTable = "chats";
  static const String contactsTable = "contacts";

  static Future<Database>? _db;

  static Future<Database> _init() async {
    _db = openDatabase(
      join(await getDatabasesPath(), database),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE $contactsTable(id INTEGER PRIMARY KEY, name TEXT, photo TEXT, trained INTEGER)",
        );
        await db.execute(
          "CREATE TABLE $chatsTable(id INTEGER PRIMARY KEY, contact_id INTEGER, text TEXT, sent INTEGER, FOREIGN KEY(contact_id) REFERENCES contacts(id))",
        );
        await db.insert(
          contactsTable,
          {
            "name": "Jane",
            "photo": janeAvatar,
            "trained": 1,
          },
        );
        // insert the default chat
        final List<MessageModel> messages = _defaultChat();
        for (MessageModel message in messages) {
          await db.insert(
            chatsTable,
            message.toJson(),
          );
        }
      },
      version: databaseVersion,
    );
    return _db!;
  }

  static Future<void> init() async {
    await _init();
  }

  static List<MessageModel> _defaultChat() {
    final List<MessageModel> messages = [];
    messages.add(MessageModel(modelInfo, 1, false));
    messages.add(MessageModel(modelDescription, 1, true));
    List<String> chat = chatExample.split("\n");
    for (int i = 0; i < chat.length - 1; i++) {
      if (chat[i].startsWith("Io:")) {
        messages.add(MessageModel(chat[i].replaceFirst("Io:", ""), 1, true));
      } else {
        messages.add(MessageModel(chat[i].replaceFirst("Bot:", ""), 1, false));
      }
    }
    return messages;
  }

  // Check if the database is initialized, if not, initialize it otherwise return the database
  static Future<Database> get _getDb async {
    if (_db == null) {
      await _init();
    }
    return _db!;
  }

  static Future<void> insert(String table, Map<String, Object?> data) async {
    final Database db = await DbHelper._getDb;
    await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, Object?>>> get(String table,
      {String? where, List<Object?>? whereArgs}) async {
    final Database db = await DbHelper._getDb;
    return await db.query(table, where: where, whereArgs: whereArgs);
  }
}
