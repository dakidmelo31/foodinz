import 'dart:math';
import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodinz/pages/meal_details.dart';
import 'package:foodinz/pages/search_page.dart';
import 'package:foodinz/pages/street_food.dart';
import 'package:foodinz/providers/category_serice.dart';
import 'package:foodinz/providers/meals.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/food.dart';
import '../providers/auth.dart';
import '../providers/data.dart';
import '../themes/light_theme.dart';
import '../widgets/slide_up_tween.dart';
import '../widgets/view_category.dart';
import 'product_details.dart';

class Showcase extends StatefulWidget {
  const Showcase({Key? key}) : super(key: key);

  @override
  State<Showcase> createState() => _ShowcaseState();
}

class _ShowcaseState extends State<Showcase> {
  late final PageController _cardPageController;
  late final PageController _cardDetailsController;
  late GoogleMapController _mapController;
  double _cardPage = 0.0, _cardDetailsPage = 0.0;
  int _cardIndex = 0;

  final _showCardDetails = ValueNotifier(true);
  @override
  void initState() {
    getCurrentLocation();
    _cardPageController = PageController(viewportFraction: .77)
      ..addListener(_cardPageListener);
    _cardDetailsController = PageController()
      ..addListener(_cardDetailsPageListener);
    super.initState();
  }

  getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    debugPrint("move the next step. again");
    debugPrint(position.toString());
    var lastPosition = await Geolocator.getLastKnownPosition();
    print("position is $lastPosition");

    lat = lastPosition!.latitude;
    long = lastPosition.longitude;
  }

  double lat = 0.0, long = 0.0;

  _cardPageListener() {
    setState(() {
      _cardPage = _cardPageController.page!;
      _cardIndex = _cardPageController.page!.round();
    });
  }

  _cardDetailsPageListener() {
    setState(() {
      _cardDetailsPage = _cardDetailsController.page!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mealsData = Provider.of<MealsData>(context);
    final userData = Provider.of<UserData>(context);
    final _restaurantsData = Provider.of<RestaurantData>(context);
    final cafeMeals = mealsData.cafeMeals;
    final streetMeals = mealsData.streetMeals;
    final classicMeals = mealsData.classicMeals;
    final specialMeals = mealsData.specialMeals;
    final _categoryData = Provider.of<CategoryData>(context);
    final _categories = _categoryData.getCategories();
    final meals = mealsData.meals;
    final size = MediaQuery.of(context).size;

    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight;
        final w = constraints.maxWidth;

        return Container(
          width: size.width,
          height: size.height,
          child: ListView(
            children: [
              Column(
                children: [
                  SlideUpTween(
                    curve: Curves.bounceInOut,
                    duration: const Duration(milliseconds: 350),
                    begin: const Offset(130, 0),
                    child: SizedBox(
                      height: 100,
                      width: size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: _categories.length,
                          itemBuilder: (_, index) {
                            return SlideUpTween(
                              begin: const Offset(80, 0),
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.bounceIn,
                              child: AnimatedPadding(
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.bounceIn,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 14),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _categoryData.selectedIndex = index;
                                    });
                                  },
                                  radius: 15,
                                  child: Chip(
                                    backgroundColor:
                                        _categoryData.selectedIndex != index
                                            ? Colors.grey.withOpacity(.15)
                                            : Theme.of(context).primaryColor,
                                    avatar: _categoryData.selectedIndex == index
                                        ? const Icon(
                                            Icons.restaurant_menu_outlined,
                                            color: Colors.white)
                                        : null,
                                    labelPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    label: Text(
                                      _categories[index].name,
                                      style: TextStyle(
                                        color:
                                            _categoryData.selectedIndex != index
                                                ? Colors.black
                                                : Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 18.0, bottom: 15),
                          child: Text("You should try these 😋😋",
                              style: Primary.heading),
                        ),
                      ),
                      SizedBox(
                        height: h * .45,
                        width: w * .85,
                        child: PageView.builder(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          controller: _cardPageController,
                          onPageChanged: (page) {
                            _cardDetailsController.animateToPage(page,
                                duration: const Duration(milliseconds: 550),
                                curve: Curves.decelerate);
                          },
                          clipBehavior: Clip.none,
                          itemCount: meals.length,
                          itemBuilder: (_, index) {
                            final Food meal = meals[index];
                            final progress = (_cardPage - index);
                            final scale = lerpDouble(1, .8, progress.abs())!;
                            final isScrolling = _cardPageController
                                .position.isScrollingNotifier.value;
                            final isCurrentPage = index == _cardIndex;
                            final isFirstPage = index == 0;
                            return Transform.scale(
                              alignment: Alignment.lerp(Alignment.centerLeft,
                                  Alignment.center, -progress),
                              scale: isScrolling && isFirstPage
                                  ? 1 - progress
                                  : scale,
                              child: GestureDetector(
                                onTap: () {
                                  _showCardDetails.value =
                                      !_showCardDetails.value;
                                  const transitionDuration =
                                      Duration(milliseconds: 250);

                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: transitionDuration,
                                      reverseTransitionDuration:
                                          transitionDuration,
                                      pageBuilder: (_, animation, __) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: SizeTransition(
                                              axis: Axis.horizontal,
                                              sizeFactor: CurvedAnimation(
                                                  parent: animation,
                                                  curve: Interval(.0, .80,
                                                      curve:
                                                          Curves.decelerate)),
                                              child: FoodDetails(meal: meal)),
                                        );
                                      },
                                    ),
                                  );
                                  Future.delayed(transitionDuration, () {
                                    _showCardDetails.value =
                                        !_showCardDetails.value;
                                  });
                                },
                                child: Hero(
                                  tag: meal.foodId.toUpperCase(),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                    transform: Matrix4.identity()
                                      ..translate(
                                        isCurrentPage ? 0.0 : -5.0,
                                        isCurrentPage ? 0.0 : 0.0,
                                      ),
                                    child: Material(
                                      shadowColor: index == _cardIndex
                                          ? const Color.fromARGB(103, 0, 0, 0)
                                          : Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          const Radius.circular(10)),
                                      elevation: 10,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        child: CachedNetworkImage(
                                          imageUrl: meal.image,
                                          alignment: Alignment.center,
                                          fit: BoxFit.cover,
                                          filterQuality: FilterQuality.high,
                                          errorWidget: (_, string, stackTrace) {
                                            return Lottie.asset(
                                                "assets/no-connection2.json");
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                      height: h * .15,
                      child: PageView.builder(
                        itemCount: meals.length,
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _cardDetailsController,
                        itemBuilder: (_, index) {
                          final Food meal = meals[index];
                          final opacity =
                              (index - _cardDetailsPage).clamp(0.0, 1.0);
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: w * 0.1,
                            ),
                            child: Opacity(
                              opacity: 1 - opacity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Hero(
                                    tag: meal.foodId,
                                    child: FittedBox(
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: Text(
                                          meal.name.toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 25,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ValueListenableBuilder<bool>(
                                    valueListenable: _showCardDetails,
                                    builder: (_, value, child) {
                                      return Visibility(
                                        child: child!,
                                        visible: value,
                                      );
                                    },
                                    child: Text(
                                      meal.categories.join(","),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )),
                  const SizedBox(height: 10), // Cafe meals
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
                            const Text("Top Shawarma Spots",
                                style: Primary.heading),
                            const Icon(Icons.arrow_forward_rounded),
                          ],
                        ),
                      ),
                    ),
                    transitionDuration: const Duration(milliseconds: 700),
                    middleColor: Colors.orange,
                    transitionType: ContainerTransitionType.fadeThrough,
                    tappable: true,
                    openBuilder: (_, closedContainer) => ViewCategory(
                        mealCategory: cafeMeals, title: " Cafe Meals"),
                  ),
                  const StreetFood(),
                  const SizedBox(
                    height: 20,
                  ),
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
                            const Text("Special Meals", style: Primary.heading),
                            const Icon(Icons.arrow_forward_rounded),
                          ],
                        ),
                      ),
                    ),
                    transitionDuration: const Duration(milliseconds: 700),
                    middleColor: Colors.orange,
                    transitionType: ContainerTransitionType.fadeThrough,
                    tappable: true,
                    openBuilder: (_, closedContainer) => ViewCategory(
                        mealCategory: cafeMeals, title: "Special Meals"),
                  ),
                  SizedBox(
                    height: h * .32,
                    width: w,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: cafeMeals.length,
                      itemBuilder: (_, index) {
                        Food meal = cafeMeals[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(children: [
                            Card(
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
                                  width: size.width * .29,
                                  height: size.height * .18,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * .29,
                              child: Column(
                                children: [
                                  Text(
                                    meal.name,
                                    style: Primary.cardText,
                                  ),
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
                                    child: Text(
                                      NumberFormat().format(
                                            meal.price.toInt(),
                                          ) +
                                          " CFA",
                                      style: Primary.orangeParagraph,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ]),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
                            const Text("Special Meals", style: Primary.heading),
                            const Icon(Icons.arrow_forward_rounded),
                          ],
                        ),
                      ),
                    ),
                    transitionDuration: const Duration(milliseconds: 700),
                    middleColor: Colors.orange,
                    transitionType: ContainerTransitionType.fadeThrough,
                    tappable: true,
                    openBuilder: (_, closedContainer) => ViewCategory(
                        mealCategory: streetMeals, title: "Street Food"),
                  ),
                  SizedBox(
                    height: h * .32,
                    width: w,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: streetMeals.length,
                      itemBuilder: (_, index) {
                        Food meal = streetMeals[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(children: [
                            Card(
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
                                  width: size.width * .29,
                                  height: size.height * .18,
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * .29,
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
                                    child: Text(
                                      NumberFormat().format(
                                            meal.price.toInt(),
                                          ) +
                                          " CFA",
                                      style: Primary.orangeParagraph,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
