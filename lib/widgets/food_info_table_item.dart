import 'package:flutter/material.dart';

class FoodInfoTableItem extends StatelessWidget {
  const FoodInfoTableItem(
      {Key? key, required this.description, required this.title})
      : super(key: key);
  final String title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            title,
            style: const TextStyle(
              color: Color.fromARGB(255, 61, 61, 61),
            ),
          ),
        ),
        Text(
          description,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
