import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../models/food.dart';

class MealsData with ChangeNotifier {
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
  List<Food> meals = [];
  List<Food> restaurantMenu = [];

  loadMeals() async {
    firestore.collection("meals").get().then((QuerySnapshot querySnapshot) {
      for (var data in querySnapshot.docs) {
        String documentId = data.id;
        print(
            "going through $documentId now and items of meals array are ${meals.length}");
        meals.add(Food(
          foodId: documentId,
          likes: convertInt(data['likes']),
          description: data['description'],
          comments: convertInt(data['comments']),
          name: data["name"],
          available: data["available"],
          image: data['image'],
          averageRating: convertInt(data["averageRating"])
              .toDouble(), //int.parse(data['averageRating'])
          price: convertDouble(data['price']),
          restaurantId: data['restaurantId'],
          gallery: convertString(data['gallery']),
          accessories: convertList(data['accessories']),
          duration: data['duration'],
          categories: convertList(data['categories']),
        ));
      }
    }).whenComplete(() {
      notifyListeners();
    });
  }

  MealsData() {
    loadMeals();
  }

  Food getMeal(String foodId) {
    return meals.firstWhere((element) => element.foodId == foodId);
  }

  void toggleFavorite(String id) {
    Food meal = restaurantMenu.firstWhere((element) => element.foodId == id);
    meal.favorite = !meal.favorite;
    notifyListeners();
  }

  void loadMenu(String id) {
    restaurantMenu.clear();
    debugPrint("restaurant id is $id");

    for (var food in meals) {
      debugPrint(food.name);
      food.restaurantId == id ? restaurantMenu.add(food) : null;
    }
    debugPrint(restaurantMenu.length.toString());
  }
}
