import 'package:flutter/material.dart';
import 'package:foodinz/widgets/recent_comments.dart';

class CommentList extends StatelessWidget {
  const CommentList({Key? key, required this.foodId, required this.name})
      : super(key: key);
  final String foodId, name;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Container(
        color: Colors.white.withOpacity(.6),
        width: size.width,
        height: size.height,
        child: Material(
          child: RecentComments(
            name: name,
            restaurantId: foodId,
            isMeal: true,
          ),
        ));
  }
}
