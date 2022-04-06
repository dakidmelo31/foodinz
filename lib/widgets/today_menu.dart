import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/providers/meals.dart';
import 'package:foodinz/widgets/food_card.dart';
import 'package:foodinz/widgets/meal_bottom_sheet.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/food.dart';

class TodayMenu extends StatelessWidget {
  const TodayMenu({Key? key, required this.restaurantId}) : super(key: key);
  final String restaurantId;

  @override
  Widget build(BuildContext context) {
    final _restaurantData = Provider.of<MealsData>(context);
    _restaurantData.loadMenu(restaurantId);
    final restaurantMenu = _restaurantData.restaurantMenu;
    final Size size = MediaQuery.of(context).size;

    final List<Food> todayMenu = _restaurantData.restaurantMenu;

    return Padding(
      padding: const EdgeInsets.only(top: 28.0),
      child: SizedBox(
        width: size.width,
        height: size.height * .25,
        child: ListView.builder(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            shrinkWrap: true,
            itemCount: todayMenu.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final Food meal = restaurantMenu[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 6),
                width: size.width * .36,
                child: InkWell(
                  onTap: () {
                    showBottomSheet(
                        elevation: 20,
                        enableDrag: true,
                        backgroundColor: Colors.black.withOpacity(.37),
                        context: context,
                        builder: (context) {
                          return MealBottomSheet(meal: meal);
                        });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                                imageUrl: meal.image,
                                alignment: Alignment.center,
                                fit: BoxFit.cover,
                                height: size.height * .17,
                                width: double.infinity),
                          ),
                          Positioned(
                            right: 5,
                            top: 8,
                            child: ClipOval(
                              child: Container(
                                color: Colors.white.withOpacity(.3),
                                child: IconButton(
                                  onPressed: () {
                                    _restaurantData.toggleFavorite(meal.foodId);
                                  },
                                  icon: meal.favorite
                                      ? Icon(Icons.favorite_rounded,
                                          color: Colors.pink)
                                      : Icon(Icons.favorite_border_rounded,
                                          color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(meal.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      Text(meal.categories.join(", "),
                          style: TextStyle(color: Colors.orange)),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
