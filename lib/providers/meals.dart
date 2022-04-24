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
        debugPrint(cat);
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
            debugPrint(cat);
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
    firestore
        .collection("meals")
        .get()
        .then((QuerySnapshot querySnapshot) {
          for (var data in querySnapshot.docs) {
            String documentId = data.id;
            debugPrint(
                "going through $documentId now and items of meals array are ${meals.length}");
            meals.add(
              Food(
                foodId: documentId,
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
              ),
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

  void toggleFavorite(String id) {
    Food meal = restaurantMenu.firstWhere((element) => element.foodId == id);

    restaurantMenu.firstWhere((element) => element.foodId == id).favorite =
        !meal.favorite;
    notifyListeners();
  }

  void toggleMeal({required String id}) {
    Food meal = meals.firstWhere((element) => element.foodId == id);

    meals.firstWhere((element) => element.foodId == id).favorite =
        !meal.favorite;
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

  updateStore(
      {required String collectionBucket,
      required String foodId,
      required dynamic value,
      required String name}) {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    FirebaseFirestore.instance
        .collection(collectionBucket)
        .where("foodId", isEqualTo: foodId)
        .get()
        .then((querySnapshot) {
      for (var document in querySnapshot.docs) {
        try {
          // Only if DocumentID has only numbers
          batch.update(document.reference, {name: value});
        } on FormatException catch (error) {
          // If a document ID is unparsable. Example "lRt931gu83iukSSLwyei" is unparsable.
          debugPrint("The document ${error.source} could not be parsed.");
          return null;
        }
      }
      return batch.commit();
    });
  }
}
