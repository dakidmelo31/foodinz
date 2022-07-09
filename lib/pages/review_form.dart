import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart' as fk;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodinz/providers/auth.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/food.dart';
import '../themes/light_theme.dart';

class ReviewForm extends StatefulWidget {
  const ReviewForm({Key? key, required this.meal, required this.restaurantId})
      : super(key: key);
  final Food meal;
  final String restaurantId;

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  TextEditingController _reviewController = TextEditingController();
  int review = 0;
  @override
  Widget build(BuildContext context) {
    final meal = widget.meal;
    final _userData = Provider.of<MyData>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: StatefulBuilder(builder: (_, setState) {
        return Material(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text("Add a review", style: Primary.bigHeading),
                const SizedBox(
                  height: 20,
                ),
                Lottie.network(
                    "https://assets5.lottiefiles.com/packages/lf20_ao823ilv.json",
                    width: 220,
                    height: 220,
                    fit: BoxFit.contain,
                    reverse: true,
                    options: LottieOptions(enableMergePaths: true)),
                Flexible(
                  child: TextField(
                    minLines: 2,
                    maxLines: 15,
                    maxLength: 500,
                    controller: _reviewController,
                    decoration: const InputDecoration(
                        label: Text("What do you think about this?"),
                        enabled: true,
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Enter your review...",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                4,
                              ),
                            ),
                            borderSide: BorderSide(
                              color: Colors.orange,
                              width: 3,
                            )),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10)),
                  ),
                ),
                SizedBox(
                  height: kToolbarHeight,
                  width: size.width,
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.heavyImpact();
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [1, 2, 3, 4, 5].map((e) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: IconButton(
                              onPressed: () {
                                debugPrint(e.toString());
                                setState(() {
                                  review = e;
                                });
                              },
                              icon: review >= e
                                  ? const Icon(
                                      Icons.star_rounded,
                                      color: Colors.amber,
                                      size: 30,
                                    )
                                  : const Icon(
                                      Icons.star_border_rounded,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Spacer(flex: 1),
                CupertinoButton.filled(
                    child: const Text("Add review"),
                    onPressed: () {
                      if (review == 0) debugPrint("add review");
                      FirebaseFirestore.instance.collection("reviews").add({
                        "restaurantId": meal.restaurantId,
                        "foodId": meal.foodId,
                        "name": meal.name,
                        "image": meal.image,
                        "description": _reviewController.text,
                        "userId": FirebaseAuth.instance.currentUser!.uid,
                        "username": _userData.user!.name,
                        "avatar": _userData.user!.image,
                        "stars": review,
                        "created_at": FieldValue.serverTimestamp(),
                      }).then((value) {
                        debugPrint("done adding review");
                        _reviewController.text = "";
                      }).catchError((onError) {
                        debugPrint(onError.toString());
                      });
                      Navigator.pop(context, true);
                    }),
                const SizedBox(
                  height: 20,
                ),
              ]),
        );
      }),
    );
  }
}