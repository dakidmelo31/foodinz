import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/pages/meal_details.dart';
import 'package:foodinz/pages/street_food_details.dart';
import 'package:foodinz/providers/meals.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/food.dart';
import '../providers/cart.dart';
import '../providers/data.dart';
import '../themes/light_theme.dart';

class StreetFood extends StatefulWidget {
  const StreetFood({Key? key}) : super(key: key);

  @override
  State<StreetFood> createState() => _StreetFoodState();
}

class _StreetFoodState extends State<StreetFood> {
  @override
  Widget build(BuildContext context) {
    final restaurantData = Provider.of<RestaurantData>(context, listen: false);
    final _cartData = Provider.of<CartData>(context, listen: true);
    final _mealsData = Provider.of<MealsData>(context, listen: true);
    final _mealList = _mealsData.breakfasts;
    debugPrint(_mealList.length.toString());

    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.orange.withOpacity(.13),
      child: Column(
        children: [
          const SizedBox(height: 50),
          SizedBox(
              width: size.width,
              height: size.height > 650 ? size.height * .35 : size.height * .45,
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                scrollDirection: Axis.horizontal,
                itemCount: _mealList.length,
                itemBuilder: (_, index) {
                  final Food food = _mealList[index];

                  final isAlreadyInCart =
                      _cartData.isAlreadyInCart(foodId: food.foodId);

                  final restaurant = restaurantData.selectRestaurant(
                      restaurantId: food.restaurantId);
                  int rating = food.comments;

                  final String myTag = food.foodId +
                      (Random().nextDouble() * -999999999999).toString();

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: double.infinity,
                    width: size.width * .5,
                    child: Column(
                      children: [
                        const Spacer(),
                        ClipOval(
                          child: GestureDetector(
                            onTap: () {
                              debugPrint("open new page");
                              const Duration transitionDuration =
                                  Duration(milliseconds: 800);
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 1600),
                                    reverseTransitionDuration:
                                        const Duration(milliseconds: 200),
                                    barrierDismissible: true,
                                    transitionsBuilder: (_, animation,
                                        anotherAnimation, child) {
                                      return SizeTransition(
                                        sizeFactor: CurvedAnimation(
                                            curve: Curves.fastOutSlowIn,
                                            parent: animation,
                                            reverseCurve: Curves.decelerate),
                                        axis: Axis.vertical,
                                        axisAlignment: 0.0,
                                        child: child,
                                      );
                                    },
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return SizeTransition(
                                        sizeFactor: CurvedAnimation(
                                            curve:
                                                Curves.fastLinearToSlowEaseIn,
                                            parent: animation,
                                            reverseCurve: Curves.decelerate),
                                        axis: Axis.vertical,
                                        axisAlignment: 0.0,
                                        child: FoodDetails(
                                          meal: food,
                                          heroTag: myTag,
                                        ),
                                      );
                                    },
                                  ));
                            },
                            child: Hero(
                              tag: food.image.toUpperCase(),
                              child: Opacity(
                                opacity: isAlreadyInCart ? .25 : 1.0,
                                child: CachedNetworkImage(
                                  imageUrl: food.image,
                                  alignment: Alignment.center,
                                  fit: BoxFit.cover,
                                  placeholder: (_, stackTrace) => Lottie.asset(
                                    "assets/loading5.json",
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                  ),
                                  filterQuality: FilterQuality.high,
                                  errorWidget: (_, string, stackTrace) {
                                    return Lottie.asset(
                                        "assets/no-connection2.json");
                                  },
                                  width: 130,
                                  height: 130,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                restaurant.address,
                                style: Primary.paragraph,
                              ),
                              IconButton(
                                  icon: const Icon(
                                    Icons.location_pin,
                                    color: Colors.pink,
                                  ),
                                  onPressed: () {
                                    debugPrint("Open map");
                                  }),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          food.name,
                          style: Primary.shawarmaHeading,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                      ],
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }
}
