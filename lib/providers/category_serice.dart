import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/models/category.dart';
import 'package:foodinz/providers/data.dart';

class CategoryData with ChangeNotifier {
  CategoryData() {
    loadCategories();
  }
  int selectedIndex = 1;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Category> _categories = [];

  List<Category> getCategories() {
    return [..._categories];
  }

  loadCategories() async {
    _firestore.collection("categories").get().then(
      (QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          String documentId = doc.id;
          _categories.add(
            Category(
              categoryId: documentId,
              count: RestaurantData.convertInt(doc['count']),
              name: doc['name'],
            ),
          );
        }
        debugPrint("categories loaded");
      },
    ).whenComplete(() {
      notifyListeners();
    });
  }
}
