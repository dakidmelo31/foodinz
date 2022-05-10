import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/food_coment.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class RecentComments extends StatefulWidget {
  const RecentComments({Key? key, required this.restaurantId})
      : super(key: key);
  final String restaurantId;

  @override
  State<RecentComments> createState() => _RecentCommentsState();
}

class _RecentCommentsState extends State<RecentComments> {
  @override
  Widget build(BuildContext context) {
    int convertInt(dynamic value) {
      if (value == null) return 0;
      var myInt = value;
      int newInt = myInt as int;

      return newInt;
    }

    int limit = 10;

    return StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection("comments")
            .where("restaurantId", isEqualTo: widget.restaurantId)
            .orderBy("time")
            .limitToLast(limit)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint(" find the error here " + snapshot.error.toString());
            return const Text("No comments available");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator.adaptive();
          }

          return Column(
            children: [
              if (snapshot.data!.docs.length < 1)
                SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Text("No comments yet.")),
              if (snapshot.data!.docs.length > 0)
                Column(
                  children: snapshot.data!.docs.map((data) {
                    String documentId = data.id;
                    final comment = Comment(
                      foodId: data['foodId'],
                      restaurantId: data['restaurantId'],
                      commentId: documentId,
                      stars: convertInt(data['stars']),
                      description: data['description'],
                      name: data["name"],
                      userId: data["userId"],
                      image: data['image'],
                      created_at: data['time'],
                    );
                    return Card(
                      color: Colors.transparent,
                      elevation: 0,
                      shadowColor: Colors.black.withOpacity(.15),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 18),
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
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              timeago.format(comment.created_at.toDate(),
                                  allowFromNow: true, locale: 'en'),
                            ),
                          ),
                        ],
                      ),
                    );
                    ;
                  }).toList(),
                ),
              if (snapshot.data!.docs.length > 0)
                TextButton(
                    onPressed: () => setState(() {
                          limit += 20;
                        }),
                    child: Text("Load More"))
            ],
          );
        });
  }
}
