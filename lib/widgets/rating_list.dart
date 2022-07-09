import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/providers/comments_service.dart';
import 'package:foodinz/widgets/recent_comments.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/food_coment.dart';
import 'package:timeago/timeago.dart' as timeago;

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
