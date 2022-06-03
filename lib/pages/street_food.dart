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

class StreetFood extends StatelessWidget {
  const StreetFood({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shawarmaMeals =
        Provider.of<MealsData>(context, listen: true).shawarmaMeals;
    final restaurantData = Provider.of<RestaurantData>(context, listen: false);
    final _cartData = Provider.of<CartData>(context, listen: true);

    // debugPrint(shawarmaMeals.length.toString());
    String imageUrl = "";
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
                itemCount: shawarmaMeals.length,
                itemBuilder: (_, index) {
                  final Food food = shawarmaMeals[index];

                  final isAlreadyInCart =
                      _cartData.isAlreadyInCart(foodId: food.foodId);

                  final restaurant = restaurantData.selectRestaurant(
                      restaurantId: food.restaurantId);
                  int rating = food.averageRating.toInt();
                  List<Widget> ratings = [];
                  for (int i = 0; i < 5; i++) {
                    if (rating <= 1) {
                      break;
                    }

                    if (i < rating) {
                      ratings.add(
                        const Icon(Icons.star_rounded, color: Colors.amber),
                      );
                    } else {
                      ratings.add(
                        Icon(Icons.star_rounded,
                            color: Colors.grey.withOpacity(.3)),
                      );
                    }
                  }
                  final String myTag = food.foodId +
                      (Random().nextDouble() * -999999999999).toString();

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: double.infinity,
                    width: size.width / 2.4,
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
                                    transitionDuration: transitionDuration,
                                    reverseTransitionDuration:
                                        transitionDuration,
                                    barrierDismissible: true,
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return ScaleTransition(
                                        scale: animation,
                                        child: FoodDetails(
                                          meal: food,
                                          heroTag: myTag,
                                        ),
                                        alignment: Alignment.bottomCenter,
                                        filterQuality: FilterQuality.high,
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
                                  filterQuality: FilterQuality.high,
                                  errorWidget: (_, string, stackTrace) {
                                    return Lottie.asset(
                                        "assets/no-connection2.json");
                                  },
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          food.categories.join(", "),
                          style: Primary.paragraph,
                        ),
                        const Spacer(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: ratings),
                        const Spacer(),
                        Row(
                          children: ratings,
                        ),
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
