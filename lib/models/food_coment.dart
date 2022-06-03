import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Comment {
  final String name,
      description,
      image,
      commentId,
      userId,
      foodId,
      restaurantId;
  final int stars;
  final Timestamp created_at;
  String avatar = '';
  Comment(
      {required this.name,
      required this.image,
      required this.restaurantId,
      required this.foodId,
      required this.created_at,
      required this.userId,
      required this.description,
      required this.commentId,
      this.avatar = "",
      required this.stars});

  Row ratingBar() {
    List<Icon> icons = [];

    for (int c = 0; c < 5; c++) {
      icons.add(
        Icon(
          Icons.star_rounded,
          color: c < stars ? Colors.amber : Colors.grey.withOpacity(.3),
          size: 14,
        ),
      );
    }
    return Row(
      children: icons,
    );
  }
}
