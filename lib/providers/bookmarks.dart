import 'package:flutter/cupertino.dart';

class BookmarkData with ChangeNotifier {
  List<String> bookmarkItems = [];

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

  bool isBookmarked(String id) {
    if (bookmarkItems.isEmpty) {
      notifyListeners();
      return false;
    }

    for (String item in bookmarkItems) {
      if (item == id) {
        notifyListeners();
        return true;
      }
    }

    notifyListeners();
    return false;
  }
}
