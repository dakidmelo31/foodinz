import 'dart:io';
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
 ''').then((value) {
      // debugPrint("messages table created successfully.");
    });
    await db.execute('''
    CREATE TABLE recentMeals(
      id int PRIMARY KEY,
      foodId TEXT,
      restaurantId TEXT
    )

''').then((value) {
      // debugPrint("recent meals created successfully");
    });
    await db.execute('''
    CREATE TABLE recentSearches(
      id int PRIMARY KEY,
      keyword TEXT
    )
''').then((value) {
      // debugPrint("recent searches table created successfully");
    });
    await db.execute('''
    CREATE TABLE favorites(
      id int PRIMARY KEY,
      foodId TEXT,
      name TEXT
    )
''').then((value) {
      debugPrint("done creating favorites table successfully");
    });
    await db.execute('''
    CREATE TABLE bookmarks(
      id int PRIMARY KEY,
      foodId TEXT,
      name TEXT
    )
''').then((value) {
      // debugPrint("done creating bookmarks table successfully");
    });
    await db.execute('''
    CREATE TABLE orders(
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
    CREATE TABLE orderedItems(
      id int PRIMARY KEY,
      orderId TEXT,
      foodId TEXT,
      name TEXT,
      quantity int,
      price int
    )
''').then((value) {
      // debugPrint("created orderd Items table successfully");
    }).then((value) => debugPrint("done creating orders table"));
    await db.execute('''
    CREATE TABLE chats(
      restaurantId TEXT,
      restaurantImage TEXT,
      userId TEXT,
      userImage TEXT,
      lastMessage TEXT,
      sender TEXT,
      Timestamp lastMessageTime
    )
''').then((value) {
      // debugPrint("created chats table successfully");
    });
    ;
    debugPrint("done building tables");
  }

  addChat({required Chat chats}) async {
    Database _db = await instance.database;
    // debugPrint("search term is: ");
    return _db
        .rawInsert(
            "INSERT INTO chats(restaurantId, restaurantImage, restaurantName, lastMessage, userImage, sender, userId, lastMessageTime) "
            "VALUES('${chats.restaurantId}', '${chats.restaurantImage}', '${chats.restaurantName}', \"${chats.lastmessage}\", '${chats.userImage}', '${chats.sender}', '${chats.userId}', Current_timestamp)")
        .then(
          (value) => debugPrint("done inserting chat overview term $value"),
        )
        .catchError((onError) {
      debugPrint("error while inserting: $onError");
    });
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
    return _db
        .insert("recentSearches", {"id": null, "keyword": keyword})
        .then((value) => debugPrint("done inserting search term $value"))
        .catchError((onError) {
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
