import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/global.dart';

import '../models/coupon_model.dart';
import '../models/restaurants.dart';

// FirebaseFirestore firestore = FirebaseFirestore.instance;

class RestaurantData with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Restaurant> restaurants = [], favorites = [];
  List<Coupon> coupon = [];
  List<String> categories = [];
  RestaurantData() {
    loadRestaurants();
  }

  Restaurant selectRestaurant({required String restaurantId}) {
    return restaurants
        .firstWhere((element) => element.restaurantId == restaurantId);
  }

  removeFavorite(String restaurantId) {
    favorites.removeWhere((element) => element.restaurantId == restaurantId);
    removeFollow(restaurantId: restaurantId);
    notifyListeners();
  }

  loadRestaurants() async {
    firestore
        .collection("restaurants")
        .snapshots()
        .listen((QuerySnapshot querySnapshot) async {
      restaurants.clear();
      favorites.clear();
      for (var doc in querySnapshot.docs) {
        String documentId = doc.id;
        bool following = await checkFollow(restaurantId: doc.id);
        debugPrint("following is now: $following");
        restaurants.add(
          Restaurant(
              address: doc["address"] ?? "",
              followers: doc["followers"] ?? 0,
              comments: doc['comments'] ?? 0,
              verified: doc['verified'] ?? 0,
              deliveryCost: doc['deliveryCost'] ?? 0,
              likes: doc['likes'] ?? 0,
              categories: List<String>.from(doc["categories"]),
              following: following,
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
      debugPrint("done with this");
      for (var element in restaurants) {
        if (await checkFollow(restaurantId: element.restaurantId)) {
          debugPrint("added to favorite Restaurants");
          favorites.add(element);
        }
      }
      debugPrint("length of favorites is: " + favorites.length.toString());
    });
    notifyListeners();
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
          followers: 0,
          restaurantId: '',
          businessPhoto: '',
          tableReservation: false,
          cash: false,
          verified: false,
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

  List<Restaurant> filterRestaurants(List<String> restaurantIds) {
    List<Restaurant> myRestaurants = [];

    for (var item in restaurants) {
      if (restaurantIds.contains(item.restaurantId)) {
        myRestaurants.add(item);
      }
    }

    return myRestaurants;
  }
}
