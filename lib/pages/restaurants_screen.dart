import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodinz/pages/restaurant_briefing.dart';
import 'package:foodinz/providers/category_serice.dart';
import 'package:foodinz/providers/meals.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../global.dart';
import '../models/restaurants.dart';
import '../providers/data.dart';
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
    final _restaurantsData = Provider.of<RestaurantData>(context, listen: true);
    final restaurants = _restaurantsData.getRestaurants;
    final size = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight;
        final w = constraints.maxWidth;

        return Column(
          children: [
            SizedBox(
              height: size.height < 600 ? h * .64 : h * 0.70,
              width: w * .94,
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

                  String tag = restaurant.address +
                      restaurant.address +
                      restaurant.restaurantId;

                  return Transform.scale(
                    alignment: Alignment.lerp(
                        Alignment.centerLeft, Alignment.center, -progress),
                    scale: isScrolling && isFirstPage ? 1 - progress : scale,
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.heavyImpact();
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
                                child: RestaurantDetails(
                                    restaurant: restaurant, restHero: tag),
                              );
                            },
                          ),
                        );
                        Future.delayed(transitionDuration, () {
                          _showCardDetails.value = !_showCardDetails.value;
                        });
                      },
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
                                        child: Hero(
                                          tag: tag + "name",
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
                              ),
                              child: Hero(
                                tag: tag,
                                child: CachedNetworkImage(
                                  placeholder: (_, __) => loadingWidget2,
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
              height: 50,
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
                          FittedBox(
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
