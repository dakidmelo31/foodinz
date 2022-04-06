import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String name, categoryId;
  final int count;

  Category({required this.name, required this.categoryId, required this.count});

  factory Category.fromJson(Map<dynamic, dynamic> json) => Category(
      categoryId: "categoryID", count: json['count'] ?? 5, name: json['name']);
}
