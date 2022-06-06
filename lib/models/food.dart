import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../providers/message_database.dart';
import 'favorite.dart';

class Food {
  String name, description, image, duration, restaurantId, foodId;
  String address = "";
  final bool available;
  final double averageRating, price;
  int likes;
  bool favorite = false;

  final int comments;
  final List<String> accessories, gallery, categories;
  List<String> compliments = [];
  Food(
      {favorite = false,
      required this.accessories,
      required this.available,
      required this.price,
      required this.categories,
      required this.averageRating,
      required this.comments,
      required this.description,
      required this.duration,
      required this.foodId,
      required this.image,
      required this.gallery,
      required this.likes,
      required this.name,
      this.address = "Molyko",
      required this.restaurantId});

  static int convertInt(dynamic value) {
    if (value == null) return 0;
    var myInt = value;
    int newInt = myInt as int;

    return newInt;
  }

  static double convertDouble(dynamic value) {
    if (value == null) return 0;
    var myInt = value;
    double newInt = myInt as double;

    return newInt;
  }

  static List<String> convertString(dynamic list) {
    if (list == null) {
      return [];
    }
    if (list.runtimeType == String) {
      String names = list as String;
      List<String> d = names.split(",");
      return d;
    }

    return [];
  }

  static List<String> convertList(dynamic list) {
    List<String> data = [];
    if (list == null) {
      return data;
    }

    for (String item in list) {
      data.add(item);
    }
    print("${data} is the list ${data.runtimeType}");

    return data;
  }

  factory Food.fromJson(AsyncSnapshot<DocumentSnapshot> documentSnapshot) {
    var favorites = DatabaseHelper.instance;

    Map<String, dynamic> data =
        documentSnapshot.data!.data()! as Map<String, dynamic>;
    String documentId = documentSnapshot.data!.id;

    bool isFavorite = favorites.checkFavorite(foodId: documentId);
    return Food(
      favorite: isFavorite,
      foodId: documentId,
      likes: convertInt(data['likes']),
      description: data['description'],
      comments: convertInt(data['comments']),
      name: data["name"],
      available: data["available"],
      image: data['image'],
      averageRating: convertInt(data["averageRating"])
          .toDouble(), //int.parse(data['averageRating'])
      price: double.parse(data['price']),
      restaurantId: data['restaurantId'],
      gallery: convertString(data['gallery']),
      accessories: convertList(data['accessories']),
      duration: data['duration'],
      categories: convertList(data['categories']),
    );
  }

  Map<String, dynamic> toJson() => _toFirestore(this);

  Map<String, dynamic> _toFirestore(Food food) => <String, dynamic>{
        "name": food.name,
        "available": food.available,
        "price": food.price,
        "image": food.image,
        "restaurantId": food.restaurantId,
        "duration": food.duration,
        "categories": food.categories,
        "gallery": food.gallery.join(","),
        "accessories": food.accessories,
        "likes": food.likes,
        "comments": food.comments,
        "averageRating": food.averageRating,
        "foodId": food.foodId,
        "description": food.description
      };

  bool complimentExists(String item) {
    bool exists = false;

    for (String data in compliments) {
      if (data == item) {
        exists = true;
      }
    }
    return exists;
  }

  toggle(String selection) {
    debugPrint("updating compliments selected");
    bool remove = false;

    for (String data in compliments) {
      if (data == selection) {
        remove = true;
      }
    }
    if (remove) {
      compliments.removeWhere((element) => element == selection);
    } else {
      compliments.add(selection);
    }
  }
}
