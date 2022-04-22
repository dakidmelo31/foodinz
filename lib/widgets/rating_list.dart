import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/providers/comments_service.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/food_coment.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentList extends StatelessWidget {
  const CommentList({Key? key, required this.foodId}) : super(key: key);
  final String foodId;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final _mealComments = Provider.of<CommentsData>(context, listen: false);
    List<Comment> allComments = _mealComments.comments;
    allComments.isEmpty ? _mealComments.loadComments(foodId) : null;

    return Container(
        color: Colors.white.withOpacity(.6),
        width: size.width,
        height: size.height,
        child: allComments.length == 0
            ? Material(
                child: Center(
                  child: Text("There is no comment for this item yet"),
                ),
              )
            : ListView.builder(
                itemCount: allComments.length,
                itemBuilder: (_, index) {
                  final comment = allComments[index];
                  return Card(
                    color: Colors.white,
                    elevation: 10,
                    shadowColor: Colors.black.withOpacity(.15),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: comment.image,
                                  errorWidget: (_, index, stackTrace) {
                                    return Lottie.asset(
                                      "assets/no-connection2.json",
                                      fit: BoxFit.contain,
                                      alignment: Alignment.center,
                                      width: 34,
                                      height: 34,
                                    );
                                  },
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                  width: 34,
                                  height: 34,
                                ),
                              ),
                              Text(
                                comment.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              comment.ratingBar(),
                            ]),
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text(comment.description),
                        ),
                        Text(
                          timeago.format(comment.created_at.toDate(),
                              allowFromNow: true, locale: 'en'),
                        ),
                      ],
                    ),
                  );
                },
              ));
  }
}
