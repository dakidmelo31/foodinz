import 'dart:math';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodinz/global.dart';
import 'package:foodinz/pages/street_food.dart';
import 'package:foodinz/providers/cart.dart';
import 'package:foodinz/providers/meals.dart';
import 'package:foodinz/widgets/view_category.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../models/food.dart';
import '../pages/meal_details.dart';
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
    var filteredMeals = Provider.of<MealsData>(context, listen: true);
    final filteredList = filteredMeals.filterCategory(keyword: widget.filter);
    Size size = MediaQuery.of(context).size;

    return Builder(builder: (context) {
      final int middleIndex = (globalCategories.length / 2).floor();
      final String middleCategory = globalCategories[middleIndex];
      if (widget.filter == middleCategory) {
        return Column(
          children: [
            const ServicesList(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Column(children: [
                OpenContainer(
                  closedElevation: 0,
                  openElevation: 0,
                  closedBuilder: (_, openContainer) => InkWell(
                    onTapDown: (details) {
                      HapticFeedback.heavyImpact();
                    },
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
                      ViewCategory(title: widget.title),
                ),
                SizedBox(
                  height:
                      filteredList.length == 1 ? size.width : size.width * .8,
                  width: size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredList.length,
                    itemBuilder: (_, index) {
                      Food meal = filteredList[index];
                      final isAlreadyInCart =
                          _cartData.isAlreadyInCart(foodId: meal.foodId);
                      final String tag = "info" +
                          meal.foodId +
                          "moreInfo" +
                          meal.address +
                          meal.foodId +
                          Random().nextInt(6000000).toString();

                      return InkWell(
                        onTap: () {
                          HapticFeedback.heavyImpact();

                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(milliseconds: 1200),
                                  transitionsBuilder:
                                      (_, animation1, animation2, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                              begin: const Offset(-1, 0),
                                              end: const Offset(0, 0))
                                          .animate(CurvedAnimation(
                                              parent: animation1,
                                              curve: Curves.elasticInOut)),
                                      child: child,
                                    );
                                  },
                                  pageBuilder: (_, animation, animation2) {
                                    return FadeTransition(
                                      opacity: CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.elasticInOut,
                                          reverseCurve: Curves.decelerate),
                                      child:
                                          FoodDetails(meal: meal, myTag: tag),
                                    );
                                  }));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    fit: StackFit.passthrough,
                                    children: [
                                      AnimatedOpacity(
                                        curve: Curves.easeInOut,
                                        duration:
                                            const Duration(milliseconds: 450),
                                        opacity: isAlreadyInCart ? .2 : 1.0,
                                        child: Hero(
                                          tag: tag,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            child: CachedNetworkImage(
                                              imageUrl: meal.image,
                                              errorWidget:
                                                  (_, style, stackTrace) {
                                                return Lottie.asset(
                                                    "assets/no-connection2.json");
                                              },
                                              filterQuality: FilterQuality.high,
                                              placeholder: (__, ___) =>
                                                  Lottie.asset(
                                                      "assets/loading5.json"),
                                              fit: BoxFit.cover,
                                              alignment: Alignment.center,
                                              width: filteredList.length == 1
                                                  ? size.width - 20
                                                  : size.width * .6,
                                              height: filteredList.length == 1
                                                  ? size.width
                                                  : 180.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (isAlreadyInCart)
                                        Align(
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text(
                                                "Already in Cart",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.deepOrange,
                                                ),
                                              ),
                                              TextButton.icon(
                                                icon: const FaIcon(
                                                    FontAwesomeIcons.trashCan),
                                                label: const Text("Drop",
                                                    style: Primary.bigHeading),
                                                onPressed: () {
                                                  _cartData.removeFromCart(
                                                      meal.foodId);
                                                  setState(() {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .hideCurrentSnackBar();
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(SnackBar(
                                                            duration:
                                                                const Duration(
                                                              milliseconds:
                                                                  1550,
                                                            ),
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                            dismissDirection:
                                                                DismissDirection
                                                                    .down,
                                                            backgroundColor:
                                                                Colors.white,
                                                            elevation: 20,
                                                            width: size.width -
                                                                10.0,
                                                            content: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Flexible(
                                                                  flex: 8,
                                                                  child: Text(
                                                                    meal.name,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        overflow:
                                                                            TextOverflow.ellipsis),
                                                                  ),
                                                                ),
                                                                const Spacer(),
                                                                const Flexible(
                                                                  flex: 2,
                                                                  child: Text(
                                                                    " Dropped",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )));
                                                  });
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: SizedBox(
                                    width: filteredList.length == 1
                                        ? size.width
                                        : size.width * .60,
                                    child: Column(
                                      children: [
                                        Text(
                                          meal.name,
                                          style: TextStyle(
                                              fontSize: filteredList.length == 1
                                                  ? 16.0
                                                  : 15.0),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (meal.likes < 10)
                                          const Icon(Icons.favorite,
                                              color: Colors.transparent,
                                              size: 15.0),
                                        if (meal.likes > 10)
                                          Row(
                                            children: [
                                              const Icon(Icons.favorite,
                                                  color: Colors.pink,
                                                  size: 15.0),
                                              Text(
                                                meal.likes > 1001
                                                    ? (meal.likes / 1000)
                                                            .toStringAsFixed(2)
                                                            .toString() +
                                                        "K"
                                                    : meal.likes > 1001
                                                        ? (meal.likes / 1000000)
                                                                .toString() +
                                                            "M"
                                                        : meal.likes.toString(),
                                                style: Primary.cardText,
                                              ),
                                            ],
                                          ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding: filteredList.length > 1
                                                ? EdgeInsets.zero
                                                : const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Hero(
                                                  tag: tag + "price",
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: Text(
                                                      NumberFormat().format(
                                                            meal.price.toInt(),
                                                          ) +
                                                          " CFA",
                                                      style: const TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.orange),
                                                    ),
                                                  ),
                                                ),
                                                Material(
                                                  elevation: 10,
                                                  color: Colors.white,
                                                  child: InkWell(
                                                    onTap: () {
                                                      HapticFeedback
                                                          .heavyImpact();

                                                      if (isAlreadyInCart) {
                                                        int quantity = _cartData
                                                            .isAvailable(
                                                                meal.foodId)!
                                                            .quantity;
                                                        quantity++;
                                                        _cartData
                                                            .removeFromCart(
                                                                meal.foodId);

                                                        _cartData
                                                            .addToCart(Cart(
                                                          name: meal.name,
                                                          foodId: meal.foodId,
                                                          image: meal.image,
                                                          price: meal.price,
                                                          restaurantId:
                                                              meal.restaurantId,
                                                          compliments:
                                                              meal.compliments,
                                                          quantity: quantity,
                                                        ));
                                                      } else {
                                                        _cartData
                                                            .addToCart(Cart(
                                                          name: meal.name,
                                                          foodId: meal.foodId,
                                                          image: meal.image,
                                                          price: meal.price,
                                                          restaurantId:
                                                              meal.restaurantId,
                                                          compliments:
                                                              meal.compliments,
                                                          quantity: 1,
                                                        ));
                                                      }

                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .hideCurrentSnackBar();
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                              duration:
                                                                  const Duration(
                                                                milliseconds:
                                                                    1550,
                                                              ),
                                                              behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                              dismissDirection:
                                                                  DismissDirection
                                                                      .down,
                                                              backgroundColor:
                                                                  Colors.white,
                                                              elevation: 20,
                                                              width:
                                                                  size.width -
                                                                      70,
                                                              content: Row(
                                                                children: [
                                                                  const Text(
                                                                    "Cart",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                  const Spacer(),
                                                                  Text(
                                                                    _cartData.myCart.length ==
                                                                            1
                                                                        ? _cartData.myCart.length.toString() +
                                                                            " item"
                                                                        : _cartData.myCart.length.toString() +
                                                                            " items",
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                  const Spacer(),
                                                                  Text(
                                                                    "${_cartData.total.toInt()} CFA",
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )));
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: isAlreadyInCart
                                                          ? const Icon(Icons
                                                              .plus_one_rounded)
                                                          : const Icon(
                                                              Icons.add,
                                                              size: 30,
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10)
                              ]),
                        ),
                      );
                    },
                  ),
                ),
              ]),
            )
          ],
        );
      }

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
                ViewCategory(title: widget.title),
          ),
          SizedBox(
            height: filteredList.length == 1 ? size.width : size.width * .8,
            width: size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: filteredList.length,
              itemBuilder: (_, index) {
                Food meal = filteredList[index];
                final isAlreadyInCart =
                    _cartData.isAlreadyInCart(foodId: meal.foodId);
                final String mealHero = "data" +
                    meal.foodId +
                    "data" +
                    meal.address +
                    meal.foodId +
                    Random().nextInt(6000000).toString();
                debugPrint("show hero string: $mealHero");

                return InkWell(
                  onTap: () {
                    HapticFeedback.heavyImpact();

                    Navigator.push(
                        context,
                        PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 1200),
                            transitionsBuilder:
                                (_, animation1, animation2, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                        begin: const Offset(-1, 0),
                                        end: const Offset(0, 0))
                                    .animate(CurvedAnimation(
                                        parent: animation1,
                                        curve: Curves.elasticInOut)),
                                child: child,
                              );
                            },
                            pageBuilder: (_, animation, animation2) {
                              return FadeTransition(
                                opacity: CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.elasticInOut,
                                    reverseCurve: Curves.decelerate),
                                child: FoodDetails(meal: meal, myTag: mealHero),
                              );
                            }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Stack(
                              alignment: Alignment.center,
                              fit: StackFit.passthrough,
                              children: [
                                AnimatedOpacity(
                                  curve: Curves.easeInOut,
                                  duration: const Duration(milliseconds: 450),
                                  opacity: isAlreadyInCart ? .2 : 1.0,
                                  child: Hero(
                                    tag: mealHero,
                                    child: ClipRRect(
                                      clipBehavior: Clip.antiAlias,
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: CachedNetworkImage(
                                        imageUrl: meal.image,
                                        errorWidget: (_, style, stackTrace) {
                                          return Lottie.asset(
                                              "assets/no-connection2.json");
                                        },
                                        filterQuality: FilterQuality.high,
                                        placeholder: (__, ___) => Lottie.asset(
                                            "assets/loading5.json"),
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center,
                                        width: filteredList.length == 1
                                            ? size.width - 20
                                            : size.width * .6,
                                        height: filteredList.length == 1
                                            ? size.width
                                            : 180.0,
                                      ),
                                    ),
                                  ),
                                ),
                                if (isAlreadyInCart)
                                  Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Already in Cart",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.deepOrange,
                                          ),
                                        ),
                                        TextButton.icon(
                                          icon: const FaIcon(
                                              FontAwesomeIcons.trashCan),
                                          label: const Text("Drop",
                                              style: Primary.bigHeading),
                                          onPressed: () {
                                            _cartData
                                                .removeFromCart(meal.foodId);
                                            setState(() {
                                              ScaffoldMessenger.of(context)
                                                  .hideCurrentSnackBar();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      duration: const Duration(
                                                        milliseconds: 1550,
                                                      ),
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      dismissDirection:
                                                          DismissDirection.down,
                                                      backgroundColor:
                                                          Colors.white,
                                                      elevation: 20,
                                                      width: size.width - 10.0,
                                                      content: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Flexible(
                                                            flex: 8,
                                                            child: Text(
                                                              meal.name,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis),
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          const Flexible(
                                                            flex: 2,
                                                            child: Text(
                                                              " Dropped",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )));
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SizedBox(
                              width: filteredList.length == 1
                                  ? size.width
                                  : size.width * .60,
                              child: Column(
                                children: [
                                  Hero(
                                    tag: mealHero + "name",
                                    child: Material(
                                      color: Colors.transparent,
                                      elevation: 0.0,
                                      child: Text(
                                        meal.name,
                                        style: TextStyle(
                                            fontSize: filteredList.length == 1
                                                ? 16.0
                                                : 15.0),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
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
                                                  ? (meal.likes / 1000000)
                                                          .toString() +
                                                      "M"
                                                  : meal.likes.toString(),
                                          style: Primary.cardText,
                                        ),
                                      ],
                                    ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: filteredList.length > 1
                                          ? EdgeInsets.zero
                                          : const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Hero(
                                            tag: mealHero + "price",
                                            child: Material(
                                              color: Colors.transparent,
                                              child: Text(
                                                NumberFormat().format(
                                                      meal.price.toInt(),
                                                    ) +
                                                    " CFA",
                                                style: const TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.orange),
                                              ),
                                            ),
                                          ),
                                          Material(
                                            elevation: 10,
                                            color: Colors.white,
                                            child: InkWell(
                                              onTap: () {
                                                HapticFeedback.heavyImpact();

                                                if (isAlreadyInCart) {
                                                  int quantity = _cartData
                                                      .isAvailable(meal.foodId)!
                                                      .quantity;
                                                  quantity++;
                                                  _cartData.removeFromCart(
                                                      meal.foodId);

                                                  _cartData.addToCart(Cart(
                                                    name: meal.name,
                                                    foodId: meal.foodId,
                                                    image: meal.image,
                                                    price: meal.price,
                                                    restaurantId:
                                                        meal.restaurantId,
                                                    compliments:
                                                        meal.compliments,
                                                    quantity: quantity,
                                                  ));
                                                } else {
                                                  _cartData.addToCart(Cart(
                                                    name: meal.name,
                                                    foodId: meal.foodId,
                                                    image: meal.image,
                                                    price: meal.price,
                                                    restaurantId:
                                                        meal.restaurantId,
                                                    compliments:
                                                        meal.compliments,
                                                    quantity: 1,
                                                  ));
                                                }

                                                ScaffoldMessenger.of(context)
                                                    .hideCurrentSnackBar();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        duration:
                                                            const Duration(
                                                          milliseconds: 1550,
                                                        ),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        dismissDirection:
                                                            DismissDirection
                                                                .down,
                                                        backgroundColor:
                                                            Colors.white,
                                                        elevation: 20,
                                                        width: size.width - 70,
                                                        content: Row(
                                                          children: [
                                                            const Text(
                                                              "Cart",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                              _cartData.myCart
                                                                          .length ==
                                                                      1
                                                                  ? _cartData
                                                                          .myCart
                                                                          .length
                                                                          .toString() +
                                                                      " item"
                                                                  : _cartData
                                                                          .myCart
                                                                          .length
                                                                          .toString() +
                                                                      " items",
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                              "${_cartData.total.toInt()} CFA",
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        )));
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: isAlreadyInCart
                                                    ? const Icon(
                                                        Icons.plus_one_rounded)
                                                    : const Icon(Icons.add,
                                                        size: 30,
                                                        color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10)
                        ]),
                  ),
                );
              },
            ),
          ),
        ]),
      );
    });
  }
}
