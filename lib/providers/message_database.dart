import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/message.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? db;
  Future<Database> get database async => db ?? await _initDatabase();

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path,
        "messages_" + DateTime.now().toString() + ".db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE messages(
      id int PRIMARY KEY,
      senderName TEXT, 
      senderId Text,
      profilePicture TEXT, 
      read int,
      name TEXT,
      message TEXT,
      messageDate datetime default current_timestamp

    )
 ''');
  }

  getMessages({required String senderId}) async {
    Database _db = await instance.database;
    var messages = await _db.query("messages", orderBy: "messageDate");
    List<Message> messageList = messages.isNotEmpty
        ? messages.map((e) => Message.fromMap(e)).toList()
        : [];
    return messageList;
  }

  getMessageOverview({required String senderId}) async {
    Database _db = await instance.database;
    var messages = await _db.query("messages",
        columns: [
          "senderId",
          "message",
          "name",
          "image",
          "read",
          "messageDate",
          "profilePicture",
          "senderName"
        ],
        distinct: true,
        orderBy: "messageDate");
    List<Message> messageList = messages.isNotEmpty
        ? messages.map((e) => Message.fromMap(e)).toList()
        : [];
    return messageList;
  }
}
