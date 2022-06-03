import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/food_coment.dart';
import '../themes/light_theme.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class RecentComments extends StatefulWidget {
  RecentComments({Key? key, required this.restaurantId, required this.isMeal})
      : super(key: key);
  final String restaurantId;
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
    int convertInt(dynamic value) {
      if (value == null) return 0;
      var myInt = value;
      int newInt = myInt as int;

      return newInt;
    }

    debugPrint("is it a meal? ${widget.isMeal}");
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 30,
      ),
      child: StreamBuilder<QuerySnapshot>(
          stream: firestore
              .collection("reviews")
              .where(widget.isMeal ? "foodId" : "restaurantId",
                  isEqualTo: widget.restaurantId)
              .orderBy("created_at", descending: true)
              .limit(limit)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint(" find the error here " + snapshot.error.toString());
              return Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    const Text("No comments available"),
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

            List<Comment> allComments = [];
            var counter = 0;
            for (var data in snapshot.data!.docs) {
              if (counter >= limit) break;
              counter++;
              String documentId = data.id;
              final comment = Comment(
                foodId: data['foodId'],
                restaurantId: data['restaurantId'],
                commentId: documentId,
                stars: convertInt(data['stars']),
                description: data['description'],
                name: FirebaseAuth.instance.currentUser != null &&
                        FirebaseAuth.instance.currentUser!.uid == data["userId"]
                    ? "You"
                    : data["name"],
                userId: data["userId"],
                image: data['image'],
                created_at: data['created_at'],
              );
              allComments.add(comment);
            }

            return Column(
              children: [
                if (snapshot.data!.docs.isNotEmpty)
                  Column(
                    children: allComments.map(
                      (data) {
                        String documentId = data.commentId;

                        if (loadMoreBtn < 1) {
                          return Column(
                            children: [
                              Card(
                                color: FirebaseAuth.instance.currentUser !=
                                            null &&
                                        FirebaseAuth
                                                .instance.currentUser!.uid ==
                                            data.userId
                                    ? const Color.fromARGB(255, 200, 255, 202)
                                    : Colors.transparent,
                                elevation:
                                    FirebaseAuth.instance.currentUser != null &&
                                            FirebaseAuth.instance.currentUser!
                                                    .uid ==
                                                data.userId
                                        ? 10
                                        : 0,
                                shadowColor: Colors.black.withOpacity(.15),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                child: Column(
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl: data.image,
                                                  errorWidget:
                                                      (_, index, stackTrace) {
                                                    return Lottie.asset(
                                                      "assets/no-connection2.json",
                                                      fit: BoxFit.contain,
                                                      alignment:
                                                          Alignment.center,
                                                      width: 34,
                                                      height: 34,
                                                    );
                                                  },
                                                  fit: BoxFit.cover,
                                                  alignment: Alignment.center,
                                                  width: 34,
                                                  height: 34,
                                                  maxHeightDiskCache: 34,
                                                  maxWidthDiskCache: 34,
                                                  memCacheHeight: 34,
                                                  memCacheWidth: 34,
                                                ),
                                              ),
                                              Text(
                                                data.name,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              data.ratingBar(),
                                              Text(
                                                timeago.format(
                                                    data.created_at.toDate(),
                                                    allowFromNow: true,
                                                    locale: 'en'),
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              )
                                            ],
                                          ),
                                        ]),
                                    Padding(
                                      padding: const EdgeInsets.all(14.0),
                                      child: Text(data.description),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(28.0),
                                child: TextButton(
                                    onPressed: () {
                                      limit += 20;
                                    },
                                    child: const Text("Load More")),
                              )
                            ],
                          );
                        }
                        loadMoreBtn--;
                        return Card(
                          color: FirebaseAuth.instance.currentUser != null &&
                                  FirebaseAuth.instance.currentUser!.uid ==
                                      data.userId
                              ? const Color.fromARGB(255, 200, 255, 202)
                              : Colors.transparent,
                          elevation:
                              FirebaseAuth.instance.currentUser != null &&
                                      FirebaseAuth.instance.currentUser!.uid ==
                                          data.userId
                                  ? 10
                                  : 0,
                          shadowColor: Colors.black.withOpacity(.15),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: data.image,
                                            errorWidget:
                                                (_, index, stackTrace) {
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
                                            maxHeightDiskCache: 34,
                                            maxWidthDiskCache: 34,
                                            memCacheHeight: 34,
                                            memCacheWidth: 34,
                                          ),
                                        ),
                                        Text(
                                          data.name,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        data.ratingBar(),
                                        Text(
                                          timeago.format(
                                              data.created_at.toDate(),
                                              allowFromNow: true,
                                              locale: 'en'),
                                          style: const TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ]),
                              Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Text(data.description),
                              ),
                            ],
                          ),
                        );
                      },
                    ).toList(),
                  ),
              ],
            );
          }),
    );
  }
}
