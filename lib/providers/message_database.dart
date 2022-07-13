import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:foodinz/models/bookmark.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/chats_model.dart';
import '../models/favorite.dart';
import '../models/message.dart';
import '../models/search.dart';

class DatabaseHelper with ChangeNotifier {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? db;
  Future<Database> get database async => db ?? await _initDatabase();

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "messages.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS  messages(
      id int PRIMARY KEY,
      senderName TEXT, 
      senderId Text,
      profilePicture TEXT, 
      read int,

      name TEXT,
      message TEXT,
      messageDate datetime default current_timestamp
    )
 ''').then((value) {
      // debugPrint("messages table created successfully.");
    });
    await db.execute('''
    CREATE TABLE IF NOT EXISTS  recentMeals(
      id int PRIMARY KEY,
      foodId TEXT,
      restaurantId TEXT
    )

''').then((value) {
      // debugPrint("recent meals created successfully");
    });
    await db.execute('''
    CREATE TABLE IF NOT EXISTS  recentSearches(
      id int PRIMARY KEY,
      keyword TEXT
    )
''').then((value) {
      // debugPrint("recent searches table created successfully");
    });
    await db.execute('''
    CREATE TABLE IF NOT EXISTS  favorites(
      foodId TEXT PRIMARY KEY
    )
''').then((value) {
      // debugPrint("done creating favorites table successfully");
    });
    await db.execute('''
    CREATE TABLE IF NOT EXISTS bookmarks(
      foodId TEXT PRIMARY KEY
    )
''').then((value) {
      // debugPrint("done creating bookmarks table successfully");
    });
    await db.execute('''
    CREATE TABLE IF NOT EXISTS  orders(
      orderId TEXT PRIMARY KEY,
      restaurantId TEXT,
      restaurantPhone TEXT,
      total TEXT,
      status TEXT
    )
''').then((value) {
      // debugPrint("done creating orders table");
    });
    await db.execute('''
    CREATE TABLE IF NOT EXISTS  orderedItems(
      id int PRIMARY KEY,
      orderId TEXT,
      foodId TEXT,
      name TEXT,
      quantity int,
      price int
    )
''').then((value) {
      // debugPrint("created orderd Items table successfully");
    }).then((value) {
      // debugPrint("done creating orders table");
    });
    // await db.execute("drop table chats");
    // await db.execute("drop table mychats");
    await db.execute('''
    CREATE TABLE IF NOT EXISTS chats(
      restaurantId TEXT,
      restaurantImage TEXT,
      restaurantName,
      userId TEXT,
      userImage TEXT,
      lastMessage TEXT,
      type TEXT,
      sender TEXT,
      lastMessageTime integer
    )
''').then((value) {
      // debugPrint("created chats table successfully");
    });
    // debugPrint("done building tables");
  }

  addFavorite({required String foodId}) async {
    Database _db = await instance.database;
    var values =
        await _db.query("favorites", where: "foodId=?", whereArgs: [foodId]);
    if (values.isEmpty) {
      await _db
          .rawInsert('INSERT INTO favorites(foodId) VALUES("$foodId")')
          .then((value) => debugPrint("done adding value: $value"));
    } else {
      await _db.delete("favorites", where: "foodId=?", whereArgs: [foodId]);
    }
  }

  removeSearch({required String keyword}) async {
    final db = await instance.database;
    await db.rawDelete("DELETE FROM recentSearches WHERE keyword=?",
        [keyword]).catchError((onError) {
      debugPrint("Done deleting");
    });
  }

  static int currentTimeInSeconds() {
    var ms = (new DateTime.now()).millisecondsSinceEpoch;
    return (ms / 1000).round();
  }

  Future<bool> checkMessageOverview({required String restaurantId}) async {
    Database db = await instance.database;

    var test = await db
        .rawQuery("SELECT * FROM chats WHERE restaurantId='$restaurantId'");

    return test.length > 0;
  }

  addChat({required Chat chats}) async {
    Database _db = await instance.database;

//check if already exists
    if (await checkMessageOverview(restaurantId: chats.restaurantId)) {
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
        "lastMessageTime": currentTimeInSeconds()
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
    // debugPrint("total chats are $total");
  }

  Future<List<Message>> getMessages({required String senderId}) async {
    Database _db = await instance.database;
    var messages = await _db.query("messages", orderBy: "messageDate");
    List<Message> messageList = messages.isNotEmpty
        ? messages.map((e) => Message.fromMap(e)).toList()
        : [];
    return messageList;
  }

  Future<List<Chat>> getChats() async {
    Database _db = await instance.database;
    var messages = await _db.query("messages", orderBy: "messageDate");
    List<Chat> messageList = messages.isNotEmpty
        ? messages.map((e) => Chat.fromMap(e)).toList()
        : [];
    return messageList;
  }

  Future<List<Search>> getRecentSearches() async {
    Database _db = await instance.database;
    var messages = await _db.query("recentSearches", orderBy: "id");
    debugPrint(messages.length.toString() + " is total searches");
    List<Search> messageList = messages.isNotEmpty
        ? messages.map((e) => Search.fromMap(e)).toList()
        : [];
    for (Search search in messageList) {
      debugPrint(search.id.toString() + ": " + search.keyword);
    }
    return messageList;
  }

  addSearch({required String keyword}) async {
    Database _db = await instance.database;
    debugPrint("search term is:     $keyword");

    if (!checkKeyword(foodId: keyword))
      return _db
          .insert("recentSearches", {"id": null, "keyword": keyword})
          .then(
              (value) async => debugPrint("done inserting search term $value"))
          .catchError((onError) async {
            assert(onError != null);
            debugPrint("error while inserting: $onError");
          });
  }

  getBookmarks() async {
    Database _db = await instance.database;
    var messages = await _db.query("bookmarks", orderBy: "id");
    List<Bookmark> messageList = messages.isNotEmpty
        ? messages.map((e) => Bookmark.fromMap(e)).toList()
        : [];
    return messageList;
  }

  deleteBookmark({required String bookmarkId}) async {
    Database _db = await instance.database;
    // _db.rawDelete('DELETE FROM bookmarks WHERE foodId = ?', [bookmarkId]);
  }

  getFavorites() async {
    Database _db = await instance.database;
    var messages = await _db.query("favorites", orderBy: "foodId");
    List<Favorite> messageList = messages.isNotEmpty
        ? messages.map((e) => Favorite.fromMap(e)).toList()
        : [];
    return messageList;
  }

  getFavoriteServices() async {
    List<String> messageList = [];
    Database _db = await instance.database;
    var messages = await _db.query("Services", orderBy: "foodId")
        as List<Map<String, String>>;
    messages.map((e) {
      messageList.add(e["serviceId"]!);
    });
    return messageList;
  }

  checkFavorite({required String foodId}) async {
    List<Favorite> favorites = await DatabaseHelper.instance.getFavorites();
    bool isFavorite = false;
    for (Favorite state in favorites) {
      if (state.foodId == foodId) {
        isFavorite = true;
      }
    }
    return isFavorite;
  }

  checkFavoriteServices({required String foodId}) async {
    List<Favorite> favorites = await DatabaseHelper.instance.getFavorites();
    bool isFavorite = false;
    for (Favorite state in favorites) {
      if (state.foodId == foodId) {
        isFavorite = true;
      }
    }
    return isFavorite;
  }

  checkKeyword({required String foodId}) async {
    List<Search> favorites = await DatabaseHelper.instance.getRecentSearches();
    bool isFavorite = false;
    for (Search state in favorites) {
      if (state.keyword == foodId) {
        isFavorite = true;
      }
    }
    return isFavorite;
  }

  Future<List<Message>>? getMessageOverview() async {
    Database _db = await instance.database;
    var messages = await _db.query("messages",
        columns: [
          "senderId",
          "message",
          "name",
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

    debugPrint(messageList.length.toString());
    return messageList;
  }
}
