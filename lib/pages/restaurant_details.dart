import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/widgets/food_info_table.dart';
import 'package:foodinz/widgets/opacity_tween.dart';
import 'package:foodinz/widgets/restaurant_info_table.dart';
import 'package:foodinz/widgets/slide_up_tween.dart';
import 'package:foodinz/widgets/stars_rating.dart';
import 'package:lottie/lottie.dart';

import '../models/food.dart';
import '../models/restaurants.dart';
import '../widgets/add_to_cart.dart';
import '../widgets/food_card.dart';
import '../widgets/promo_code.dart';
import '../widgets/recent_comments.dart';
import '../widgets/today_menu.dart';

class RestaurantDetails extends StatelessWidget {
  const RestaurantDetails({Key? key, required this.restaurant})
      : super(key: key);
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight;
        final w = constraints.maxWidth;
        return Scaffold(
          floatingActionButton: FloatingActionButton.small(
              onPressed: () {},
              backgroundColor: Colors.grey,
              child: const Icon(Icons.message_rounded, color: Colors.white)),
          body: CustomScrollView(
            scrollDirection: Axis.vertical,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  )
                ],
                floating: true,
                pinned: false,
                backgroundColor: Colors.white,
                expandedHeight: h * .5,
                flexibleSpace: FlexibleSpaceBar(
                  background: SizedBox(
                    width: w,
                    height: h * .6,
                    child: InkWell(
                      onDoubleTap: () {},
                      child: Hero(
                        tag: restaurant.businessPhoto,
                        child: FoodCard(image: restaurant.businessPhoto),
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const Spacer(),
                    Hero(
                      tag: restaurant.restaurantId,
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Card(
                            color: Colors.white,
                            elevation: 15,
                            shadowColor: Colors.grey.withOpacity(.25),
                            margin: EdgeInsets.symmetric(
                              horizontal: w * 0.03,
                              vertical: 10,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: w * 0.1,
                                vertical: 10,
                              ),
                              child:
                                  RestaurantInfoTable(restaurant: restaurant),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        OpacityTween(
                            begin: 0.0,
                            child: SlideUpTween(
                                begin: const Offset(-30, 30),
                                child: PromoCode(
                                    restaurantId: restaurant.restaurantId))),
                      ],
                    ), //meal.averageRating

                    const Spacer(),

                    OpacityTween(
                      child: SlideUpTween(
                        begin: const Offset(-30, 30),
                        child: TodayMenu(
                          restaurantId: restaurant.restaurantId,
                        ),
                      ),
                    ),
                    const Spacer(flex: 5),
                    const Padding(
                      padding:
                          EdgeInsets.only(top: 15.0, left: 10.0, bottom: 10.0),
                      child: Text(
                        "Recent Comments",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, left: 10.0, bottom: 10.0),
                      child:
                          RecentComments(restaurantId: restaurant.restaurantId),
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
