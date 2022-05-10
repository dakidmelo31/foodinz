import 'package:flutter/material.dart';
import 'package:foodinz/models/chats_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/message.dart';

class DBManager {
  static final DBManager instance = DBManager._init();
  static Database? _database;
  DBManager._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB("chats.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE IF NOT EXISTS chats (

  ${ChatFields.restaurantId} TEXT PRIMARY KEY,
  ${ChatFields.restaurantName} TEXT NOT NULL,
  ${ChatFields.lastMessageTime} TEXT NOT NULL,
  ${ChatFields.lastMessage} TEXT NOT NULL,
  ${ChatFields.sender} TEXT NOT NULL,
  ${ChatFields.userImage} TEXT NOT NULL,
  ${ChatFields.restaurantImage} TEXT NOT NULL,
  ${ChatFields.userId} TEXT NOT NULL
    )
''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS chat_messages (
      msgId INTEGER PRIMARY KEY AUTOINCREMENT,
      restaurantId TEXT NOT NULL,
      restaurantImage TEXT NOT NULL,
      restaurantName TEXT NOT NULL,
      userId TEXT NOT NULL,
      userImage TEXT NOT NULL,
      lastMessage TEXT NOT NULL,
      sender TEXT NOT NULL,
      lastMessageTime TEXT NOT NULL
    )
''');
  }

  Future<int> addOverview({required Chat chat}) async {
    final db = await instance.database;
    chat.toString();

    if (await selectOverview(restaurantId: chat.restaurantId) != null) {
      debugPrint("user exists");
      return -1;
    }

    final id = await db.insert("chats", chat.toMap());
    return id;
  }

  Future<List<Chat>> getChatOverviews() async {
    final db = await instance.database;
    var allMaps =
        await db.query("chats", orderBy: '${ChatFields.lastMessageTime} DESC');
    return allMaps.map((e) => Chat.fromMap(e)).toList();
  }

  Future updateOverview(
      {required String restaurantId,
      required String message,
      required String time}) async {
    final db = await instance.database;
    db.rawUpdate(
        "UPDATE chats SET lastMessage= ?, lastMessageTime = ? WHERE restaurantId = ?",
        [message, time, restaurantId]);
  }

  Future<int> delete({required String restaurantId}) async {
    final db = await instance.database;
    return db
        .delete("chats", where: 'restaurantId = ?', whereArgs: [restaurantId]);
  }

  Future<Chat?> selectOverview({required String restaurantId}) async {
    final db = await instance.database;
    Chat allOverviews;
    var list = await db.query("chats",
        columns: ChatFields.values,
        where: '${ChatFields.restaurantId} = ?',
        whereArgs: [restaurantId]);
    if (list.isNotEmpty) {
      return Chat.fromMap(list.first);
    }

    return null;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  overviewExists({required String restaurantId}) async {
    final db = await instance.database;
    var list = await db.query("chats",
        columns: ChatFields.values,
        where: '${ChatFields.restaurantId} = ?',
        whereArgs: [restaurantId]);

    if (list.isNotEmpty) {
      return true;
    }

    return false;
  }

  Future<List<Chat>> getOverviews() async {
    Database _db = await instance.database;
    var messages = await _db.query("chats", orderBy: "lastMessageTime");
    List<Chat> messageList = messages.isNotEmpty
        ? messages.map((e) {
            var chat = Chat.fromMap(e);
            return chat;
          }).toList()
        : [];
    return messageList;
  }

// Add chat
  addChat({required Chat chats}) async {
    Database _db = await instance.database;

//check if already exists
    if (await overviewExists(restaurantId: chats.restaurantId)) {
      debugPrint("restaurant already there");
    } else {
      // debugPrint("search term is: ");

      var row = {
        "restaurantId": chats.restaurantId,
        "restaurantImage": chats.restaurantImage,
        "restaurantName": chats.restaurantName,
        "lastMessage": chats.lastmessage,
        "userImage": chats.userImage,
        "sender": chats.sender,
        "userId": chats.userId,
        "lastMessageTime": chats.lastMessageTime.toIso8601String()
      };
      return _db
          .insert("chats", row)
          .then(
            (value) => debugPrint("$value added to overview"),
          )
          .catchError((onError) {
        debugPrint("error while inserting: $onError");
      });
    }

    var length = await _db.rawQuery("SELECT * FROM chats");
    var total = length.length;
    debugPrint("total chats are $total");
  }

  dropTable({required String tableName}) async {
    var db = await instance.database;
    debugPrint("adding now");
    await db
        .execute("DROP TABLE '${tableName}'")
        .then((value) => debugPrint("done dropping table"))
        .catchError((onError) {
      debugPrint(onError.toString());
    });
  }

  truncateTable({required String tableName}) async {
    final db = await instance.database;
    db.rawQuery('''
DELETE FROM '${tableName}';
VACUUM; 
    ''');
  }
}
