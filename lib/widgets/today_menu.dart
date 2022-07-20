import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/pages/meal_details.dart';
import 'package:foodinz/providers/meals.dart';
import 'package:foodinz/widgets/transitions.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/food.dart';

class TodayMenu extends StatelessWidget {
  const TodayMenu({Key? key, required this.restaurantId}) : super(key: key);
  final String restaurantId;

  @override
  Widget build(BuildContext context) {
    final _restaurantData = Provider.of<MealsData>(context);
    _restaurantData.loadMenu(restaurantId);
    final restaurantMenu = _restaurantData.restaurantMenu;
    final Size size = MediaQuery.of(context).size;

    final List<Food> todayMenu = _restaurantData.restaurantMenu;

    return Padding(
      padding: const EdgeInsets.only(top: 28.0),
      child: SizedBox(
        width: size.width,
        height: size.height * .25,
        child: ListView.builder(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            shrinkWrap: true,
            itemCount: todayMenu.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final Food meal = restaurantMenu[index];
              final String myTag = meal.foodId +
                  (Random().nextDouble() * 999999999999).toString();

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: size.width * .36,
                child: InkWell(
                  onTap: () {
                    // showBottomSheet(
                    //     elevation: 20,
                    //     enableDrag: true,
                    //     backgroundColor: Colors.black.withOpacity(.37),
                    //     context: context,
                    //     builder: (context) {
                    //       return MealBottomSheet(meal: meal);
                    //     });

                    Navigator.push(
                      context,
                      HorizontalSizeTransition(
                        child: FoodDetails(
                          meal: meal,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: meal.image,
                              placeholder: (_, data) {
                                return Lottie.asset("assets/loading5.json");
                              },
                              alignment: Alignment.center,
                              fit: BoxFit.cover,
                              height: size.height * .17,
                              width: double.infinity,
                            ),
                          ),
                          Positioned(
                            right: 5,
                            top: 8,
                            child: Card(
                              color: Colors.white,
                              elevation: 8.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(children: [
                                  Text(
                                    meal.duration,
                                  )
                                ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        meal.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
