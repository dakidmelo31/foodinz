import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../global.dart';
import '../models/food.dart';
import 'message_database.dart';

class MealsData with ChangeNotifier {
  List<Food> meals = [], filteredMeals = [], breakfasts = [], myFavorites = [];

  void runFilter(String filter) {
    filteredMeals.clear();
    meals.map((e) {
      if (e.categories.contains(filter)) {
        breakfasts.add(e);
      }
    });
    notifyListeners();
  }

  updateMeal({required String foodId, required int newValue}) {
    getMeal(foodId).comments = newValue;
    notifyListeners();
  }

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
        .snapshots()
        .listen((QuerySnapshot querySnapshot) async {
      meals.clear();
      myFavorites.clear();
      for (var data in querySnapshot.docs) {
        String foodId = data.id;
        // debugPrint(
        //     "going through $foodId now and items of meals array are ${meals.length}");

        Food fd = Food(
            favorite: false,
            foodId: foodId,
            likes: data['likes'] as int,
            description: data['description'],
            comments: data['comments'] as int,
            name: data["name"],
            available: data["available"],
            image: data['image'],
            averageRating: 0,
            price: (data['price']) as double,
            restaurantId: data['restaurantId'],
            gallery: List<String>.from(data['gallery']),
            compliments: List<String>.from(data['accessories']),
            ingredients: List<String>.from(data['ingredients']),
            accessories: List<String>.from(data['accessories']),
            duration: data['duration'],
            categories: List<String>.from(data['categories']));

        fd.favorite = await checkLike(foodId: foodId);
        debugPrint(fd.likes.toString());

        meals.add(
          fd,
        );
        if (await checkLike(foodId: fd.foodId)) {
          myFavorites.add(fd);
          debugPrint("added meal to liked meals");
          debugPrint("myFavorites length: " + myFavorites.length.toString());
        }
        meals.shuffle();
        for (var element in meals) {
          if (element.favorite && !myFavorites.contains(element)) {
            debugPrint("added to favorites");
            myFavorites.add(element);
          }
        }
        debugPrint(
            "length of favorite meals is: " + myFavorites.length.toString());
      }
      for (Food d in meals) {
        if (d.categories.contains("Breakfast")) {
          breakfasts.add(d);
        }
      }
      debugPrint("loaded breakfast");
    });
    notifyListeners();
  }

  removeFavorite(String foodId) async {
    myFavorites.removeWhere((element) => element.foodId == foodId);
    await removeFromLikes(foodId: foodId);
    notifyListeners();
  }

  MealsData() {
    loadMeals();
  }

  Food getMeal(String foodId) {
    return meals.firstWhere((element) => element.foodId == foodId);
  }

  List<Food> filterMeals(List<String> foodIds) {
    List<Food> myMeals = [];

    for (var item in meals) {
      if (foodIds.contains(item.foodId)) {
        myMeals.add(item);
      }
    }

    return myMeals;
  }

  void toggleMeal({required String foodId}) async {
    Food meal = meals.firstWhere((element) => element.foodId == foodId);
    bool likedAlready = await checkLike(foodId: foodId);

    if (!await checkLike(foodId: foodId)) {
      firestore.collection("meals").doc(foodId).get().then((value) async {
        Map<String, dynamic> data = value.data() as Map<String, dynamic>;
        int likes = data['likes'];
        debugPrint("current likes is: $likes");

        likes += 1;
        debugPrint("new likes is: $likes");
        if (myFavorites.any((element) => element.foodId != foodId)) {
          //add only 1
          myFavorites.add(getMeal(foodId));
        }

        firestore
            .collection("meals")
            .doc(foodId)
            .update({"likes": likes})
            .then((value) => debugPrint("done adding like"))
            .catchError((onError) {
              debugPrint("Error while updating likes: $onError");
            });
        addToLikes(foodId: foodId);
      });
    } else {
      if (myFavorites.any((element) => element.foodId == foodId)) {
        //check if it exists
        myFavorites.remove(getMeal(foodId));
      }
      firestore.collection("meals").doc(foodId).get().then((value) {
        Map<String, dynamic> data = value.data() as Map<String, dynamic>;
        int likes = data['likes'];
        debugPrint("current likes is: $likes");
        likes -= 1;
        debugPrint("new likes is: $likes");

        firestore
            .collection("meals")
            .doc(foodId)
            .update({"likes": likes})
            .then((value) => debugPrint("done reducing like"))
            .catchError((onError) {
              debugPrint("Error while updating likes: $onError");
            });
      }).then((value) async {
        removeFromLikes(foodId: foodId);
      });
      notifyListeners();
    }

    toggleFoodLike(foodId: foodId);

    if (meal.favorite) {
      //reduce likes
      meals.firstWhere((element) => element.foodId == foodId).likes =
          meal.likes - 1;
    } else {
      //add like
      meals.firstWhere((element) => element.foodId == foodId).likes =
          meal.likes + 1;
    }
    meals.firstWhere((element) => element.foodId == foodId).favorite =
        !meal.favorite;
    meal.likes = meal.likes < 0 ? 0 : meal.likes;
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
}
