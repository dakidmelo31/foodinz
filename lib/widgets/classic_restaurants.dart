import 'dart:math';
import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/pages/meal_details.dart';
import 'package:foodinz/providers/category_serice.dart';
import 'package:foodinz/providers/meals.dart';
import 'package:foodinz/widgets/view_category.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/food.dart';
import '../models/restaurants.dart';
import '../pages/restaurant_details.dart';
import '../providers/data.dart';
import '../themes/light_theme.dart';
import '../widgets/slide_up_tween.dart';

class ClassicRestaurantsScreen extends StatefulWidget {
  ClassicRestaurantsScreen({Key? key}) : super(key: key);

  @override
  State<ClassicRestaurantsScreen> createState() =>
      _ClassicRestaurantsScreenState();
}

class _ClassicRestaurantsScreenState extends State<ClassicRestaurantsScreen> {
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
    final restaurants = _restaurantsData.restaurants;
    final size = MediaQuery.of(context).size;
    final carouselHeight = 300.0;
    final carouselWidth = 300.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight;
        final w = constraints.maxWidth;

        return Column(
          children: [
            const SizedBox(height: 10), // Cafe meals
            OpenContainer(
              closedElevation: 0,
              openElevation: 0,
              closedBuilder: (_, openContainer) => InkWell(
                onTap: openContainer,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text("Top Caters In Buea",
                              style: Primary.heading),
                          Text("Amazing cooks for hire")
                        ],
                      ),
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
                  Scaffold(body: Center(child: Text("list of caters"))),
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
                itemCount: restaurants.length,
                itemBuilder: (_, index) {
                  final Restaurant restaurant = restaurants[index];
                  final progress = (_cardPage - index);
                  final scale = lerpDouble(1, .8, progress.abs())!;
                  final isScrolling =
                      _cardPageController.position.isScrollingNotifier.value;
                  final isCurrentPage = index == _cardIndex;
                  final isFirstPage = index == 0;
                  return Transform.scale(
                    alignment: Alignment.lerp(
                        Alignment.centerLeft, Alignment.center, -progress),
                    scale: isScrolling && isFirstPage ? 1 - progress : scale,
                    child: GestureDetector(
                      onTap: () {
                        _showCardDetails.value = !_showCardDetails.value;
                        const transitionDuration = Duration(milliseconds: 550);

                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: transitionDuration,
                            reverseTransitionDuration: transitionDuration,
                            pageBuilder: (_, animation, __) {
                              return FadeTransition(
                                opacity: animation,
                                child:
                                    RestaurantDetails(restaurant: restaurant),
                              );
                            },
                          ),
                        );
                        Future.delayed(transitionDuration, () {
                          _showCardDetails.value = !_showCardDetails.value;
                        });
                      },
                      child: Hero(
                        tag: restaurant.businessPhoto,
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
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            elevation: 10,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: GridTile(
                                header: Row(
                                  children: [
                                    SizedBox(
                                      width: constraints.maxWidth - 170,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Icons.stars_rounded,
                                              color: Colors.white, size: 16),
                                          IconButton(
                                            onPressed: () {
                                              debugPrint("add heart");
                                            },
                                            icon: Icon(Icons.favorite_outlined),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                footer: ClipRRect(
                                  child: Container(
                                    height: 70,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.transparent,
                                          Colors.transparent,
                                          Colors.black.withOpacity(.5),
                                        ],
                                      ),
                                    ),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 3,
                                        sigmaY: 3,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 18.0, horizontal: 10),
                                        child: Text(
                                          restaurant.companyName,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: restaurant.businessPhoto,
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
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
                height: h * .25,
                child: PageView.builder(
                  itemCount: restaurants.length,
                  physics: NeverScrollableScrollPhysics(),
                  controller: _cardDetailsController,
                  itemBuilder: (_, index) {
                    final Restaurant restaurant = restaurants[index];
                    final opacity = (index - _cardDetailsPage).clamp(0.0, 1.0);
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
                              tag: restaurant.restaurantId,
                              child: FittedBox(
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: Text(
                                    restaurant.companyName.toUpperCase(),
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
                                restaurant.openingTime +
                                    " " +
                                    restaurant.closingTime,
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
          ],
        );
      },
    );
  }
}
