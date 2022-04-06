import 'package:flutter/material.dart';
import 'package:foodinz/models/food.dart';
import 'package:foodinz/providers/meals.dart';
import 'package:provider/provider.dart';

class FoodAppBar extends StatelessWidget {
  const FoodAppBar({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios_new),
      ),
      title: Text(title),
    );
  }
}
