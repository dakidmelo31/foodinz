import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:foodinz/models/bookmark.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/favorite.dart';
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
    await db.execute('''
    CREATE TABLE recentMeals(
      id int PRIMARY KEY,
      foodId TEXT,
      restaurantId TEXT
    )

''');
    await db.execute('''
    CREATE TABLE recentSearches(
      id int PRIMARY KEY,
      keyword TEXT
    )
''');
    await db.execute('''
    CREATE TABLE favorites(
      id int PRIMARY KEY,
      foodId TEXT,
      name TEXT
    )
''');
    await db.execute('''
    CREATE TABLE bookmarks(
      id int PRIMARY KEY,
      foodId TEXT,
      name TEXT
    )
''');
    await db.execute('''
    CREATE TABLE orders(
      id int PRIMARY KEY,
      orderId TEXT,
      total TEXT,

    )
''');
    debugPrint("done building tables");
  }

  getMessages({required String senderId}) async {
    Database _db = await instance.database;
    var messages = await _db.query("messages", orderBy: "messageDate");
    List<Message> messageList = messages.isNotEmpty
        ? messages.map((e) => Message.fromMap(e)).toList()
        : [];
    return messageList;
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
    _db.rawDelete('DELETE FROM bookmarks WHERE foodId = ?', [bookmarkId]);
  }

  getFavorites() async {
    Database _db = await instance.database;
    var messages = await _db.query("favorites", orderBy: "id");
    List<Favorite> messageList = messages.isNotEmpty
        ? messages.map((e) => Favorite.fromMap(e)).toList()
        : [];
    return messageList;
  }

  checkFavorite({required String foodId}) async {
    List<Favorite> favorites = DatabaseHelper.instance.getFavorites();
    bool isFavorite = false;
    for (Favorite state in favorites) {
      if (state.foodId == foodId) {
        isFavorite = true;
      }

      return isFavorite;
    }
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
