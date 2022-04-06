import 'package:flutter/material.dart';

class FoodDateCard extends StatelessWidget {
  const FoodDateCard({Key? key, required this.date, required this.isSelected})
      : super(key: key);
  final DateTime date;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.orange, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${date.day} ${date.month}",
                style:
                    TextStyle(color: isSelected ? Colors.orange : Colors.grey)),
            SizedBox(
              height: 5,
            ),
            Text("${date.hour}",
                style:
                    TextStyle(color: isSelected ? Colors.white : Colors.grey)),
          ],
        ));
  }
}
