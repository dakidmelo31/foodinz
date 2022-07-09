import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/food_coment.dart';
import '../models/review_models.dart';
import '../themes/light_theme.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class RecentComments extends StatefulWidget {
  const RecentComments(
      {Key? key,
      required this.restaurantId,
      required this.isMeal,
      required this.name})
      : super(key: key);
  final String restaurantId, name;
  final bool isMeal;

  @override
  State<RecentComments> createState() => _RecentCommentsState();
}

class _RecentCommentsState extends State<RecentComments> {
  bool loadMore = false;
  @override
  void initState() {
    // TODO: implement initState
    // fixReviews();
    super.initState();
  }

  int limit = 10;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    debugPrint("is it a meal? ${widget.isMeal}");
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 30,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: Theme.of(context).primaryColor,
                    size: 77.0,
                  ),
                  Text("All Reviews")
                ],
              ),
              SizedBox(
                width: size.width * .65,
                child: Text(
                  widget.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 24.0),
                ),
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection("reviews")
                  .where(widget.isMeal ? "foodId" : "restaurantId",
                      isEqualTo: widget.restaurantId)
                  .orderBy("created_at", descending: true)
                  .limit(limit)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  debugPrint(
                      " find the error here " + snapshot.error.toString());
                  return Material(
                    color: Colors.transparent,
                    child: Column(
                      children: const [
                        Text("No comments available"),
                      ],
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Lottie.asset(
                    "assets/search-list.json",
                    width: 300,
                    height: 200,
                    fit: BoxFit.contain,
                    alignment: Alignment.topCenter,
                    reverse: true,
                    options: LottieOptions(enableMergePaths: true),
                  );
                }
                if (snapshot.data!.docs.length > limit) loadMore = true;

                int loadMoreBtn = limit - 1;

                List<ReviewModel> allComments = [];
                var counter = 0;
                allComments = snapshot.data!.docs.map((e) {
                  final review = e.data() as Map<String, dynamic>;
                  var current = ReviewModel.fromMap(review);
                  current.reviewId = e.id;
                  return current;
                }).toList();

                return Column(
                  children: [
                    if (allComments.isNotEmpty)
                      Column(
                        children: allComments.map(
                          (item) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 30.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl: item.avatar,
                                                alignment: Alignment.center,
                                                fit: BoxFit.cover,
                                                errorWidget: (_, __, ___) =>
                                                    Lottie.asset(
                                                        "assets/no-connection.json"),
                                                placeholder: (
                                                  _,
                                                  __,
                                                ) =>
                                                    Lottie.asset(
                                                        "assets/loading7.json"),
                                                fadeInCurve: Curves
                                                    .fastLinearToSlowEaseIn,
                                                width: 45.0,
                                                height: 45.0,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            item.username,
                                            style: const TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              for (var i = 0; i < 5; i++)
                                                Icon(
                                                  Icons.star_rounded,
                                                  color: i <= item.rating
                                                      ? Colors.green
                                                      : Colors.grey
                                                          .withOpacity(.3),
                                                  size: 15.0,
                                                ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          item.created_at.day.toString() +
                                              "/" +
                                              item.created_at.month.toString() +
                                              "/" +
                                              item.created_at.year.toString(),
                                          style: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          size.width - ((size.width / 30) * 2),
                                      child: Text(item.description))
                                ],
                              ),
                            );
                          },
                        ).toList(),
                      ),
                  ],
                );
              }),
        ],
      ),
    );
  }
}
