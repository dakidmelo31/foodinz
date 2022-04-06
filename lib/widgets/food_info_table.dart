import 'package:flutter/material.dart';
import 'package:foodinz/widgets/food_info_table_item.dart';
import 'package:intl/intl.dart';

import '../models/food.dart';

class FoodInfoTable extends StatelessWidget {
  const FoodInfoTable({Key? key, required this.meal}) : super(key: key);
  final Food meal;

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat(
      "###,###,###",
    );
    final price = priceFormat.format(meal.price);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FoodInfoTableItem(description: "$price CFA", title: "Unit Price"),
        FoodInfoTableItem(description: meal.duration, title: "Prep Time"),
        FoodInfoTableItem(
            description: meal.available ? "Yes" : "No", title: "Available"),
      ],
    );
  }
}
