import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/coupon_model.dart';
import '../models/restaurants.dart';

// FirebaseFirestore firestore = FirebaseFirestore.instance;

class RestaurantData with ChangeNotifier {
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

    return data;
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Restaurant> restaurants = [];
  List<Coupon> coupon = [];
  List<String> categories = [];
  RestaurantData() {
    loadRestaurants();
  }

  Restaurant selectRestaurant({required String restaurantId}) {
    return restaurants
        .firstWhere((element) => element.restaurantId == restaurantId);
  }

  loadRestaurants() async {
    firestore.collection("restaurants").get().then(
      (QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          String documentId = doc.id;
          restaurants.add(
            Restaurant(
                address: doc["address"] ?? "",
                comments: doc['comments'] ?? 0,
                deliveryCost: doc['deliveryCost'] ?? 0,
                likes: doc['likes'] ?? 0,
                categories: List<String>.from(doc["categories"]),
                gallery: List<String>.from(doc["gallery"]),
                lat: doc["lat"] ?? 0.0,
                long: doc["long"] ?? 0.0,
                avatar: doc['avatar'] ?? "",
                businessPhoto: doc['businessPhoto'] ?? "",
                cash: doc['cash'] ?? false,
                closingTime: doc['closingTime'] ?? "",
                companyName: doc['companyName'] ?? "",
                email: doc['email'] ?? "",
                foodReservation: doc['foodReservation'] ?? false,
                ghostKitchen: doc['ghostKitchen'] ?? false,
                homeDelivery: doc['homeDelivery'] ?? false,
                momo: doc['momo'] ?? false,
                name: doc['name'] ?? "",
                openingTime: doc['openTime'] ?? "",
                phoneNumber: doc['phone'] ?? "",
                restaurantId: documentId,
                specialOrders: doc['specialOrders'] ?? false,
                tableReservation: doc['tableReservation'] ?? false,
                username: doc['username'] ?? ""),
          );
        }
        restaurants.shuffle();
      },
    ).then((value) {
      debugPrint("done with this");
    }).whenComplete(() {
      notifyListeners();
    });
  }

  Restaurant getRestaurant(String documentId) {
    return restaurants.firstWhere(
      (element) => element.restaurantId == documentId,
      orElse: () => Restaurant(
          address: '',
          name: '',
          categories: [],
          gallery: [],
          long: 0.0,
          lat: 0.0,
          restaurantId: '',
          businessPhoto: '',
          tableReservation: false,
          cash: false,
          momo: false,
          specialOrders: false,
          avatar: '',
          closingTime: '',
          openingTime: '',
          companyName: '',
          username: '',
          email: '',
          foodReservation: false,
          ghostKitchen: false,
          homeDelivery: false,
          phoneNumber: ''),
    );
  }

  List<Restaurant> get getRestaurants => [...restaurants];
}
