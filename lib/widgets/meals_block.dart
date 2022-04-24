import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/providers/cart.dart';
import 'package:foodinz/providers/meals.dart';
import 'package:foodinz/widgets/view_category.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/food.dart';
import '../themes/light_theme.dart';

class MealsBlock extends StatefulWidget {
  const MealsBlock({Key? key, required this.filter, required this.title})
      : super(key: key);
  final String filter;
  final String title;

  @override
  State<MealsBlock> createState() => _MealsBlockState();
}

class _MealsBlockState extends State<MealsBlock> {
  @override
  Widget build(BuildContext context) {
    final _cartData = Provider.of<CartData>(context, listen: true);
    final filteredMeals = Provider.of<MealsData>(context, listen: true);
    final filteredList = filteredMeals.filterCategory(keyword: widget.filter);
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(children: [
        OpenContainer(
          closedElevation: 0,
          openElevation: 0,
          closedBuilder: (_, openContainer) => InkWell(
            onTap: openContainer,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.title, style: Primary.heading),
                  const Icon(Icons.arrow_forward_rounded),
                ],
              ),
            ),
          ),
          transitionDuration: const Duration(milliseconds: 700),
          middleColor: Colors.orange,
          transitionType: ContainerTransitionType.fadeThrough,
          tappable: true,
          openBuilder: (_, closedContainer) =>
              ViewCategory(mealCategory: filteredList, title: widget.title),
        ),
        SizedBox(
          height: size.height * .42,
          width: size.width,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: filteredList.length,
            itemBuilder: (_, index) {
              Food meal = filteredList[index];
              final isAlreadyInCart =
                  _cartData.isAlreadyInCart(foodId: meal.foodId);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.passthrough,
                      children: [
                        Opacity(
                          opacity: isAlreadyInCart ? .2 : 1.0,
                          child: Card(
                            elevation: 5,
                            shadowColor: Colors.grey.withOpacity(.4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                imageUrl: meal.image,
                                errorWidget: (_, style, stackTrace) {
                                  return Lottie.asset(
                                      "assets/no-connection2.json");
                                },
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                width: size.width * .40,
                              ),
                            ),
                          ),
                        ),
                        if (isAlreadyInCart)
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Already in Cart",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: size.width * .40,
                    child: Column(
                      children: [
                        Text(
                          meal.name,
                          style: Primary.cardText,
                        ),
                        if (meal.likes < 10)
                          const Icon(Icons.favorite,
                              color: Colors.transparent, size: 14),
                        if (meal.likes > 10)
                          Row(
                            children: [
                              const Icon(Icons.favorite,
                                  color: Colors.pink, size: 14),
                              Text(
                                meal.likes > 1001
                                    ? (meal.likes / 1000)
                                            .toStringAsFixed(2)
                                            .toString() +
                                        "K"
                                    : meal.likes > 1001
                                        ? (meal.likes / 1000000).toString() +
                                            "M"
                                        : meal.likes.toString(),
                                style: Primary.cardText,
                              ),
                            ],
                          ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                NumberFormat().format(
                                      meal.price.toInt(),
                                    ) +
                                    " CFA",
                                style: Primary.orangeParagraph,
                              ),
                              Material(
                                elevation: 10,
                                color: Colors.white,
                                child: InkWell(
                                  onTap: () {
                                    debugPrint("add to cart");
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.add,
                                        size: 30, color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10)
                ]),
              );
            },
          ),
        ),
      ]),
    );
  }
}
