import 'package:flutter/material.dart';

class StreedFoodDetails extends StatelessWidget {
  const StreedFoodDetails({Key? key, required this.restaurantId})
      : super(key: key);
  final String restaurantId;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Center(child: Text("food details")),
      ),
    );
  }
}
