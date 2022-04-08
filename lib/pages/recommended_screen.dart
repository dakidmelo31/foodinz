import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/pages/meal_details.dart';
import 'package:foodinz/pages/street_food.dart';
import 'package:foodinz/providers/category_serice.dart';
import 'package:foodinz/providers/meals.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/food.dart';
import '../providers/data.dart';
import '../themes/light_theme.dart';
import '../widgets/slide_up_tween.dart';

class RecommendedScreen extends StatefulWidget {
  RecommendedScreen({Key? key}) : super(key: key);

  @override
  State<RecommendedScreen> createState() => _RecommendedScreenState();
}

class _RecommendedScreenState extends State<RecommendedScreen> {
  late final PageController _cardPageController;
  late final PageController _cardDetailsController;
  double _cardPage = 0.0, _cardDetailsPage = 0.0;
  int _cardIndex = 0;

  final _showCardDetails = ValueNotifier(true);
  @override
  void initState() {
    _cardPageController = PageController(viewportFraction: .77)
      ..addListener(_cardPageListener);
    _cardDetailsController = PageController()
      ..addListener(_cardDetailsPageListener);
    super.initState();
  }

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
    final _restaurantsData = Provider.of<RestaurantData>(context);
    final _categoryData = Provider.of<CategoryData>(context);
    final _categories = _categoryData.getCategories();
    final meals = mealsData.meals;
    final size = MediaQuery.of(context).size;
    final carouselHeight = 300.0;
    final carouselWidth = 300.0;
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
                    duration: Duration(milliseconds: 350),
                    begin: Offset(130, 0),
                    child: SizedBox(
                      height: 100,
                      width: size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemCount: _categories.length,
                          itemBuilder: (_, index) {
                            return SlideUpTween(
                              begin: Offset(80, 0),
                              duration: Duration(milliseconds: 500),
                              curve: Curves.bounceIn,
                              child: AnimatedPadding(
                                duration: Duration(milliseconds: 350),
                                curve: Curves.bounceIn,
                                padding: EdgeInsets.symmetric(
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
                                        ? Icon(Icons.restaurant_menu_outlined,
                                            color: Colors.white)
                                        : null,
                                    labelPadding: EdgeInsets.symmetric(
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
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 18.0, bottom: 15),
                          child: Text("You should try these 😋😋",
                              style: Primary.bigHeading),
                        ),
                      ),
                      SizedBox(
                        height: h * .45,
                        width: w * .75,
                        child: PageView.builder(
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          controller: _cardPageController,
                          onPageChanged: (page) {
                            _cardDetailsController.animateToPage(page,
                                duration: Duration(milliseconds: 550),
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
                                      Duration(milliseconds: 550);

                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: transitionDuration,
                                      reverseTransitionDuration:
                                          transitionDuration,
                                      pageBuilder: (_, animation, __) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: FoodDetails(meal: meal),
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
                                  tag: meal.image,
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
                                          ? Color.fromARGB(103, 0, 0, 0)
                                          : Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      elevation: 10,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
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
                        physics: NeverScrollableScrollPhysics(),
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
                  const SizedBox(height: 10),
                  StreetFood()
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
