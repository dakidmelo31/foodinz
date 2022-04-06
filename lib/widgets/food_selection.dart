import 'package:flutter/material.dart';

class FoodSelection extends StatefulWidget {
  const FoodSelection({Key? key, required this.foodId}) : super(key: key);
  final String foodId;

  @override
  State<FoodSelection> createState() => _FoodSelectionState();
}

class _FoodSelectionState extends State<FoodSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Add meal and select amount")));
  }
}
