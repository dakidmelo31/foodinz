import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../models/cart.dart';
import '../models/food_coment.dart';

class CommentsData with ChangeNotifier {
  List<Comment> comments = [];
  static int convertInt(dynamic value) {
    if (value == null) return 0;
    var myInt = value;
    int newInt = myInt as int;

    return newInt;
  }

  void addComment(Comment item) {
    comments.add(item);
    notifyListeners();
  }

  Comment? myComments(String id) {
    if (comments.isEmpty) return null;
    for (Comment item in comments) {
      if (item.userId == id) {
        return item;
      }
    }
    return null;
  }

  bool loadAgain = true;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  loadComments(String foodId) async {
    loadAgain = false; // prevent from reloading
    firestore
        .collection("comments")
        .where("foodId", isEqualTo: foodId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var data in querySnapshot.docs) {
        String documentId = data.id;
        addComment(Comment(
          foodId: data['foodId'],
          restaurantId: data['restaurantId'],
          commentId: documentId,
          avatar: data['avatar'],
          stars: convertInt(data['stars']),
          description: data['description'],
          name: data["name"],
          userId: data["userId"],
          image: data['image'],
          created_at: data['time'],
        ));
      }
    }).whenComplete(() {
      notifyListeners();
    });
  }

  void removeComment(String id) {
    comments.removeWhere((element) => element.userId == id);
    notifyListeners();
  }
}
