import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/global.dart';
import 'package:foodinz/models/chats_model.dart';
import 'package:foodinz/models/message_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBManager {
  static final DBManager instance = DBManager._init();
  static Database? _database;
  DBManager._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB("foodin.db");
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

  Future<List<MessageData>> restaurantChats() async {
    Database _db = await instance.database;
    // await _db.execute('DROP table chats').catchError((onError) {
    //   debugPrint("error found: $onError");
    // });
    var messages = await _db.query("chats", orderBy: "lastMessageTime");
    debugPrint(messages.join());
    List<MessageData> messageList = [];

    for (Map<String, dynamic> e in messages) {
      debugPrint("going through number 1");
      DateTime date = DateTime.tryParse(e["lastMessageTime"]) as DateTime;
      MessageData chat = MessageData(
          message: e["lastMessage"],
          restaurantId: e["restaurantId"],
          messageDate: date,
          senderId: e["sender"],
          profilePicture: e["userImage"]);
      messageList.add(chat);
    }

    messageList.sort(((b, a) => a.messageDate.compareTo(b.messageDate)));
    return messageList;
  }

// Add chat
  addChat({required Chat chat}) async {
    Database _db = await instance.database;

//check if already exists
    if (await overviewExists(restaurantId: chat.restaurantId)) {
      debugPrint("restaurant already there");
    } else {
      // debugPrint("search term is: ");

      var row = {
        "restaurantId": chat.restaurantId,
        "restaurantImage": chat.restaurantImage,
        "restaurantName": chat.restaurantName,
        "lastMessage": chat.lastmessage,
        "userImage": chat.userImage,
        "sender": chat.sender,
        "userId": chat.userId,
        "lastMessageTime": chat.lastMessageTime.toIso8601String()
      };
      _db
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

    debugPrint("Move to chat screen");
  }

// Add chat
  updateChat({required Chat chat}) async {
    Database _db = await instance.database;

    var row = {
      "restaurantId": chat.restaurantId,
      "lastMessage": chat.lastmessage,
      "lastMessageTime": chat.lastMessageTime.toIso8601String()
    };
    _db
        .rawUpdate(
            "UPDATE chats SET lastMessage = ?, lastMessageTime = ? WHERE restaurantId = ?",
            [
              chat.lastmessage,
              chat.lastMessageTime.toIso8601String(),
              chat.restaurantId
            ])
        .then((value) => debugPrint("done updating"))
        .catchError((onError) {
          debugPrint("error found: $onError");
        });
    _db
        .update("chats", row,
            where: "restaurantId=?", whereArgs: [chat.restaurantId])
        .then(
          (value) => debugPrint("$value added to overview"),
        )
        .catchError((onError) {
          debugPrint("error while inserting: $onError");
        });

    var length = await _db.rawQuery("SELECT * FROM chats");
    var total = length.length;
    debugPrint("total chats are $total");

    debugPrint("Move to chat screen");
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

deleteChatOverview({required String restaurantId}) async {
  Database _db = await DBManager.instance.database;
  _db.rawDelete("DELETE FROM chats WHERE restaurantId = ?",
      [restaurantId]).catchError((onError) {
    debugPrint(onError.toString());
  }).then((value) => debugPrint("done deleting chat"));
}

sendMessage({required Chat chat}) async {
  DBManager.instance.addChat(chat: chat);
  updateMessage(
      message: chat.lastmessage,
      newTime: chat.lastMessageTime,
      resturantId: chat.restaurantId);
  firestore
      .collection("messages")
      .add(chat.toMap())
      .then((value) => debugPrint("done adding message"))
      .catchError((onError) {
    debugPrint("error found: $onError");
  });
}

updateMessage(
    {required String message,
    required DateTime newTime,
    required String resturantId}) async {
  Database _db = await DBManager.instance.database;
  _db
      .rawUpdate(
          "UPDATE chats SET lastMessage = ?, lastMessageTime = ? WHERE restaurantId = ?",
          [message, newTime.toIso8601String(), resturantId])
      .then((value) => debugPrint("updated successfully"))
      .catchError((onError) {
        debugPrint(onError.toString());
      });
}

updateTables(
    {required String collection,
    required String id,
    required Map<String, dynamic> newVal,
    required bool merge}) async {
  firestore.collection("restaurants").get().then((snapshot) {
    for (var data in snapshot.docs) {
      firestore
          .collection("restaurants")
          .doc(data.id)
          .set(newVal, SetOptions(merge: merge));
    }
  });
}
