import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/coupon_model.dart';
import '../models/food.dart';
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

  loadRestaurants() async {
    firestore.collection("restaurants").get().then(
      (QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          String documentId = doc.id;
          restaurants.add(
            Restaurant(
                address: doc["address"] ?? "",
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
      },
    ).whenComplete(() {
      notifyListeners();
    });
  }

  Restaurant getRestaurant(String documentId) {
    return restaurants
        .firstWhere((element) => element.restaurantId == documentId);
  }

  List<Restaurant> get getRestaurants => [...restaurants];
}
