import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:foodinz/providers/global_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqlite_api.dart';

import '../models/favorite.dart';
import '../models/food.dart';
import 'message_database.dart';

class MealsData with ChangeNotifier {
  static int convertInt(dynamic value) {
    if (value == null) return 0;
    var myInt = value;
    int newInt = myInt as int;

    return newInt;
  }

  static double convertDouble(dynamic value) {
    if (value == null) return 0;
    var myInt = value + 0.0;
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
  List<Food> meals = [],
      popularMeals = [],
      streetMeals = [],
      cafeMeals = [],
      traditionalMeals = [],
      shawarmaMeals = [],
      homeDelivery = [];
  List<Food> restaurantMenu = [];
  List<Food> searchList = [];
  List<Food> search({required String keyword}) {
    searchList.clear();

    for (Food item in meals) {
      if (item.name.toLowerCase().contains(
                keyword.toLowerCase(),
              ) ||
          item.description.toLowerCase().contains(
                keyword.toLowerCase(),
              ) ||
          item.accessories.contains(
            keyword.toLowerCase(),
          ) ||
          item.compliments.contains(
            keyword.toLowerCase(),
          )) {
        searchList.add(item);
      }
    }

    notifyListeners();
    return searchList;
  }

  List<Food> filterCategory({required String keyword}) {
    List<Food> filterList = [];

    for (Food item in meals) {
      for (String cat in item.categories) {
        if (keyword.toLowerCase().contains("dessert")) {
          if (cat.toLowerCase().contains(keyword.toLowerCase()) ||
              cat.toLowerCase().contains("cake") ||
              cat.toLowerCase().contains("dessert") ||
              cat.toLowerCase().contains("birthday") ||
              cat.toLowerCase().contains("party") ||
              cat.toLowerCase().contains("cream") ||
              cat.toLowerCase().contains("sweet")) {
            // debugPrint(cat);
            filterList.add(item);
            break;
          }
        } else if (cat.toLowerCase().contains(keyword.toLowerCase())) {
          // debugPrint(cat);
          filterList.add(item);
          break;
        } else if (keyword.toLowerCase().contains("grocery")) {
          if (cat.toLowerCase().contains(keyword.toLowerCase()) ||
              cat.toLowerCase().contains("spice") ||
              cat.toLowerCase().contains("market") ||
              cat.toLowerCase().contains("vegetables") ||
              cat.toLowerCase().contains("healthy") ||
              cat.toLowerCase().contains("fruit")) {
            // debugPrint(cat);
            filterList.add(item);
            break;
          }
        }
      }
    }

    // notifyListeners();
    return filterList;
  }

  loadMeals() async {
    var favorites = DatabaseHelper.instance;

    firestore
        .collection("meals")
        .get()
        .then((QuerySnapshot querySnapshot) async {
          for (var data in querySnapshot.docs) {
            String foodId = data.id;
            // debugPrint(
            //     "going through $foodId now and items of meals array are ${meals.length}");

            Food fd = Food(
              favorite: false,
              foodId: foodId,
              likes: convertInt(data['likes']),
              description: data['description'],
              comments: convertInt(data['comments']),
              name: data["name"],
              available: data["available"],
              image: data['image'],
              averageRating: convertInt(data["averageRating"])
                  .toDouble(), //int.parse(data['averageRating'])
              price: convertDouble(data['price']) + 0.0,
              restaurantId: data['restaurantId'],
              gallery: convertString(data['gallery']),
              accessories: convertList(data['accessories']),
              duration: data['duration'],
              categories: convertList(data['categories']),
            );

            fd.favorite =
                await DBManager.instance.checkFavorite(foodId: foodId);
            meals.add(
              fd,
            );
          }

          for (Food food in meals) {
            for (String cat in food.categories) {
              switch (cat.toLowerCase()) {
                case "cafe":
                case "cafe food":
                  cafeMeals
                      .removeWhere((element) => element.foodId == food.foodId);

                  cafeMeals.add(food);
                  break;

                case "special dish":
                case "specials":
                  traditionalMeals
                      .removeWhere((element) => element.foodId == food.foodId);
                  traditionalMeals.add(food);
                  break;

                case "classic":
                case "classic food":
                  cafeMeals
                      .removeWhere((element) => element.foodId == food.foodId);
                  cafeMeals.add(food);
                  break;

                case "street":
                case "street food":
                  streetMeals
                      .removeWhere((element) => element.foodId == food.foodId);

                  streetMeals.add(food);
                  break;
                case "shawarma":
                case "shawarma special":
                  shawarmaMeals
                      .removeWhere((element) => element.foodId == food.foodId);

                  shawarmaMeals.add(food);
                  break;
              }
            }
          }
        })
        .then((value) {})
        .whenComplete(() {
          notifyListeners();
        });
  }

  MealsData() {
    loadMeals();
  }

  Food getMeal(String foodId) {
    return meals.firstWhere((element) => element.foodId == foodId);
  }

  void toggleFavorite(String id) async {
    Food meal = restaurantMenu.firstWhere((element) => element.foodId == id);
    final dbManager = await DBManager.instance;

    dbManager.addFavorite(foodId: id);
    restaurantMenu.firstWhere((element) => element.foodId == id).favorite =
        !meal.favorite;

    notifyListeners();
  }

  void toggleMeal({required String id}) {
    Food meal = meals.firstWhere((element) => element.foodId == id);
    final dbManager = DBManager.instance;

    dbManager.addFavorite(foodId: id);
    if (meal.favorite) {
      //reduce likes
      meals.firstWhere((element) => element.foodId == id).likes =
          meal.likes - 1;
    } else {
      //add like
      meals.firstWhere((element) => element.foodId == id).likes =
          meal.likes + 1;
    }
    meals.firstWhere((element) => element.foodId == id).favorite =
        !meal.favorite;
    notifyListeners();
  }

  void loadMenu(String id) {
    restaurantMenu.clear();
    // debugPrint("restaurant id is $id");

    for (var food in meals) {
      // debugPrint(food.name);
      food.restaurantId == id ? restaurantMenu.add(food) : null;
    }
    // debugPrint(restaurantMenu.length.toString());
  }

  toggleLike(
      {required String userId,
      required String foodId,
      required dynamic value,
      required String name}) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    final _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey(foodId)) {
      debugPrint("already liked");
    } else {
      debugPrint("add like");
      FirebaseFirestore.instance
          .collection("meals")
          .where("foodId", isEqualTo: foodId)
          .get()
          .then(
        (querySnapshot) {
          for (var document in querySnapshot.docs) {
            int likes = document.data()["likes"];
            likes++;
            FirebaseFirestore.instance.collection("meals").doc(foodId).update(
              {
                "likes": likes,
              },
            ).then(
              (value) {
                debugPrint("done updating");
              },
            ).catchError(
              (error) {
                debugPrint("Error while updating: $error");
              },
            );
          }
        },
      );
    }
  }
}
