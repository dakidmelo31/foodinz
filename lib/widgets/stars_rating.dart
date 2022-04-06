import 'package:flutter/material.dart';

class StarsRating extends StatelessWidget {
  const StarsRating({Key? key, required this.stars}) : super(key: key);
  final double stars;

  @override
  Widget build(BuildContext context) {
    List<Icon> starsList = [];
    double c = 0.0;
    for (; c < stars; c += 1.0) {
      starsList.add(Icon(
        Icons.star_rate_rounded,
        color: Colors.amber,
      ));
    }
    for (c; c < stars + 1; c += 1.0) {
      starsList.add(Icon(Icons.star_rate_rounded,
          color: Colors.grey.withOpacity(.3), size: 30));
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: starsList.map((e) => e).toList(),
    );
  }
}
