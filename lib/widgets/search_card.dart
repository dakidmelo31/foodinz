import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:foodinz/pages/meal_details.dart';
import 'package:foodinz/pages/recommended_screen.dart';
import 'package:foodinz/pages/restaurant_details.dart';
import 'package:foodinz/providers/cart.dart';
import 'package:foodinz/widgets/row_data.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../models/food.dart';
import '../models/restaurants.dart';

class SearchCard extends StatefulWidget {
  const SearchCard({Key? key, required this.food, required this.restaurant})
      : super(key: key);
  final Food food;
  final Restaurant restaurant;

  @override
  State<SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  bool isExpanded = true;
  late final Food food;
  late final Restaurant restaurant;
  @override
  void initState() {
    food = widget.food;
    restaurant = widget.restaurant;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String compliments =
        food.compliments.join(", ") + food.accessories.join(",");
    Size size = MediaQuery.of(context).size;
    final String myTag =
        food.foodId + (Random().nextDouble() * 999999999999).toString();

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: AnimatedContainer(
        margin: EdgeInsets.symmetric(
          horizontal: isExpanded ? 25 : 5,
          vertical: 5,
        ),
        padding: EdgeInsets.all(20),
        height: isExpanded ? 100 : 330,
        curve: Curves.fastLinearToSlowEaseIn,
        duration: Duration(milliseconds: 800),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xFF6F12E8).withOpacity(.5),
              blurRadius: 20,
              offset: Offset(5, 10),
            ),
          ],
          color: const Color(0xFF6F12E8),
          borderRadius: BorderRadius.all(
            Radius.circular(
              isExpanded ? 20 : 0,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width * .6,
                  child: Text(
                    food.name,
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                // Icon(
                //   isExpanded
                //       ? Icons.keyboard_arrow_down
                //       : Icons.keyboard_arrow_up,
                //   color: Colors.white,
                //   size: 27,
                // ),
                ClipOval(
                  child: Container(
                    color: food.available ? Colors.greenAccent : Colors.amber,
                    width: 58,
                    height: 58,
                    child: Center(
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: food.image,
                          placeholder: (_, value) => Lottie.asset(
                              "assets/loading-animation.json",
                              fit: BoxFit.contain),
                          width: 54,
                          height: 54,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          errorWidget: (_, __, ___) =>
                              Lottie.asset("assets/waiting-pigeon.json"),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            isExpanded ? SizedBox() : SizedBox(height: 20),
            AnimatedCrossFade(
              firstChild: Text("", style: TextStyle(fontSize: 0)),
              secondChild: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RowData(
                          property: "Dish Maker",
                          value: restaurant.companyName),
                      RowData(
                          property: "Opening Time",
                          value: restaurant.openingTime),
                      RowData(
                          property: "Closes at", value: restaurant.closingTime),
                      RowData(
                          property: "Stock",
                          value: food.available ? "Available" : "Unavailable"),
                      RowData(property: "Eaten with", value: compliments),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                            "Unit Price: " +
                                NumberFormat().format(food.price) +
                                " CFA",
                            style: const TextStyle(
                                fontSize: 27, color: Colors.white)),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          color: Colors.deepOrange,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  FadeSearch(
                                      page: FoodDetails(
                                    meal: food,
                                  )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 15),
                              child: Text("See Full Details",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                        Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  FadeSearch(
                                      page: RestaurantDetails(
                                          restaurant: restaurant)));
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 15),
                              child: Text("Visit Dish Maker",
                                  style: TextStyle(color: Color(0xFF6F12E8))),
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              final _cartData =
                                  Provider.of<CartData>(context, listen: false);
                              if (!_cartData.isAlreadyInCart(
                                  foodId: food.foodId)) {
                                _cartData.addToCart(
                                  Cart(
                                    foodId: food.foodId,
                                    image: food.image,
                                    name: food.name,
                                    price: food.price,
                                    quantity: 1,
                                    restaurantId: food.restaurantId,
                                    compliments: [],
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(child: Text("Cart Updated")),
                                  ),
                                  elevation: 10,
                                  dismissDirection: DismissDirection.startToEnd,
                                ));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child:
                                        Center(child: Text("Already in cart")),
                                  ),
                                  elevation: 10,
                                  dismissDirection: DismissDirection.startToEnd,
                                ));
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.plus_one_outlined,
                                  size: 27, color: Color(0xFF6F12E8)),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 800),
              reverseDuration: Duration.zero,
              sizeCurve: Curves.fastLinearToSlowEaseIn,
            )
          ],
        ),
      ),
    );
  }
}
