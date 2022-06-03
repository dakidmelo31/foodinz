import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/pages/restaurant_briefing.dart';
import 'package:foodinz/providers/category_serice.dart';
import 'package:foodinz/providers/meals.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../models/restaurants.dart';
import '../providers/data.dart';
import '../widgets/slide_up_tween.dart';
import 'restaurant_details.dart';

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({Key? key, required this.lat, required this.long})
      : super(key: key);
  final double lat, long;

  @override
  State<RestaurantsScreen> createState() => _RecommendedScreenState();
}

class _RecommendedScreenState extends State<RestaurantsScreen> {
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
    double lat = widget.lat;
    double long = widget.long;
    final mealsData = Provider.of<MealsData>(context);
    final _restaurantsData = Provider.of<RestaurantData>(context);
    final _categoryData = Provider.of<CategoryData>(context);
    final _categories = _categoryData.getCategories();
    final restaurants = _restaurantsData.getRestaurants;
    final size = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight;
        final w = constraints.maxWidth;

        return Column(
          children: [
            SizedBox(
              height: 80,
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
                                ? const Icon(Icons.restaurant_menu_outlined,
                                    color: Colors.white)
                                : null,
                            labelPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            label: Text(
                              _categories[index].name,
                              style: TextStyle(
                                color: _categoryData.selectedIndex != index
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
            SizedBox(
              height: size.height < 600 ? h * .4 : h * .55,
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
                allowImplicitScrolling: true,
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
                                ? const Color.fromARGB(103, 0, 0, 0)
                                : Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            elevation: 10,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              child: GridTile(
                                header: Row(
                                  children: [
                                    SizedBox(
                                      width: constraints.maxWidth - 170,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Icon(Icons.stars_rounded,
                                              color: Colors.white, size: 16),
                                          IconButton(
                                            onPressed: () {
                                              debugPrint("add heart");
                                            },
                                            icon: const Icon(Icons.star_rounded,
                                                size: 30, color: Colors.amber),
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
                                        child: FittedBox(
                                          child: Text(
                                            restaurant.companyName,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                overflow:
                                                    TextOverflow.ellipsis),
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
            const SizedBox(height: 30),
            SizedBox(
              height: size.height < 600 ? h * .25 : h * .2,
              child: PageView.builder(
                itemCount: restaurants.length,
                physics: const NeverScrollableScrollPhysics(),
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
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text("Phone Number"),
                              Text(restaurant.phoneNumber
                                  .split("+237")
                                  .join(" ")),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text("Home Delivery"),
                              Text(
                                  restaurant.homeDelivery
                                      ? "Available"
                                      : "Not available",
                                  style: TextStyle(
                                      color: restaurant.homeDelivery
                                          ? Colors.green
                                          : Colors.pink)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ValueListenableBuilder<bool>(
                                valueListenable: _showCardDetails,
                                builder: (_, value, child) {
                                  return Visibility(
                                    child: child!,
                                    visible: value,
                                  );
                                },
                                child: Text(
                                  "Open until " + restaurant.closingTime,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (restaurant.ghostKitchen)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Text("You can hire us"),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
