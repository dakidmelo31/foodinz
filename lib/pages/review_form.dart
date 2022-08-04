import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart' as fk;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodinz/providers/auth.dart';
import 'package:foodinz/providers/meals.dart';
import 'package:foodinz/providers/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/food.dart';
import '../models/service.dart';
import '../themes/light_theme.dart';

class ReviewForm extends StatefulWidget {
  ReviewForm(
      {Key? key,
      required this.meal,
      required this.restaurantId,
      this.isFood = true})
      : super(key: key);
  final dynamic meal;
  bool isFood;
  final String restaurantId;

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  TextEditingController _reviewController = TextEditingController();
  int review = 0;
  @override
  Widget build(BuildContext context) {
    Food? meal = widget.isFood ? widget.meal as Food : null;
    ServiceModel? service = widget.isFood ? null : widget.meal as ServiceModel;

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
                Lottie.asset("assets/review.json",
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
                      HapticFeedback.heavyImpact();

                      if (widget.isFood) {
                        if (meal == null) {
                          return;
                        }
                        if (review == 0) debugPrint("add review");
                        FirebaseFirestore.instance.collection("reviews").add({
                          "restaurantId": meal.restaurantId,
                          "foodId": meal.foodId,
                          "name": meal.name,
                          "image": meal.image,
                          "description": _reviewController.text,
                          "userId": FirebaseAuth.instance.currentUser!.uid,
                          "username": _userData.user.name,
                          "avatar": _userData.user.image,
                          "stars": review,
                          "created_at": FieldValue.serverTimestamp(),
                        }).then((value) {
                          debugPrint("done adding review");
                          _reviewController.text = "";
                        }).catchError((onError) {
                          debugPrint(onError.toString());
                        });

                        FirebaseFirestore.instance
                            .collection("meals")
                            .doc(meal.foodId)
                            .get()
                            .then((value) {
                          var data = value["comments"] as int;
                          data += 1;
                          Provider.of<MealsData>(context, listen: true)
                              .updateMeal(foodId: meal.foodId, newValue: data);

                          FirebaseFirestore.instance
                              .collection("meals")
                              .doc(meal.foodId)
                              .update({"comments": data});
                        });
                        Provider.of<MealsData>(context, listen: false)
                            .updateMeal(
                                foodId: meal.foodId,
                                newValue: meal.comments + 1);

                        Navigator.pop(context, true);
                      } else {
                        if (service == null) {
                          return;
                        }
                        if (review == 0) debugPrint("add review");
                        FirebaseFirestore.instance.collection("reviews").add({
                          "restaurantId": service.restaurantId,
                          "foodId": service.serviceId,
                          "name": service.name,
                          "image": service.image,
                          "description": _reviewController.text,
                          "userId": FirebaseAuth.instance.currentUser!.uid,
                          "username": _userData.user.name,
                          "avatar": _userData.user.image,
                          "stars": review,
                          "created_at": FieldValue.serverTimestamp(),
                        }).then((value) {
                          debugPrint("done adding review");
                          _reviewController.text = "";
                        }).catchError((onError) {
                          debugPrint(onError.toString());
                        });

                        FirebaseFirestore.instance
                            .collection("services")
                            .doc(service.serviceId)
                            .get()
                            .then((value) {
                          var data = value["comments"] as int;
                          data += 1;
                          Provider.of<ServicesData>(context, listen: false)
                              .updateService(
                                  serviceId: service.serviceId, newValue: data);

                          FirebaseFirestore.instance
                              .collection("services")
                              .doc(service.serviceId)
                              .update({"comments": data});
                        });

                        Navigator.pop(context, true);
                      }
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
