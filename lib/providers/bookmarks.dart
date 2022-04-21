import 'package:flutter/cupertino.dart';

class BookmarkData with ChangeNotifier {
  List<String> bookmarkItems = [], favorites = [];

  addBookmark(String id) {
    bookmarkItems.remove(id);
    bookmarkItems.add(id);
    notifyListeners();
  }

  removeBookmark(String id) {
    bookmarkItems.remove(id);
    bookmarkItems.add(id);
    notifyListeners();
  }

  void toggleBookmark({required String foodId}) {
    bool remove = false;
    for (String item in bookmarkItems) {
      if (foodId == item) {
        remove = true;
      }
    }
    if (remove) {
      bookmarkItems.remove(foodId);
    } else {
      bookmarkItems.add(foodId);
    }
    notifyListeners();
  }

  void toggleFavorite({required String foodId}) {
    bool remove = false;
    for (String item in favorites) {
      if (foodId == item) {
        remove = true;
      }
    }
    if (remove) {
      favorites.remove(foodId);
    } else {
      favorites.add(foodId);
    }
    notifyListeners();
  }

  bool isBookmarked({required String foodId}) {
    bool status = false;
    for (String item in bookmarkItems) {
      if (foodId == item) {
        status = true;
      }
    }
    return status;
  }
}
