import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/pages/meal_details.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../models/food.dart';
import '../themes/light_theme.dart';

class ViewCategory extends StatelessWidget {
  const ViewCategory(
      {Key? key, required this.title, required this.mealCategory})
      : super(key: key);
  final String title;
  final List<Food> mealCategory;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            title,
          ),
          centerTitle: true,
        ),
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3,
              mainAxisSpacing: 1,
              crossAxisSpacing: 3,
            ),
            physics: const BouncingScrollPhysics(),
            itemCount: mealCategory.length,
            itemBuilder: (_, index) {
              Food meal = mealCategory[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(children: [
                  Expanded(
                    flex: 4,
                    child: Card(
                      elevation: 5,
                      shadowColor: Colors.grey.withOpacity(.4),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                              reverseTransitionDuration:
                                  const Duration(milliseconds: 500),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      FadeTransition(
                                opacity: animation,
                                child: FoodDetails(
                                  meal: meal,
                                ),
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Hero(
                            tag: meal.image.toUpperCase() + "aaa",
                            child: CachedNetworkImage(
                              imageUrl: meal.image,
                              placeholder: (_, data) {
                                return Lottie.asset("assets/loading5.json");
                              },
                              errorWidget: (_, style, stackTrace) {
                                return Lottie.asset(
                                    "assets/no-connection2.json");
                              },
                              fit: BoxFit.cover,
                              width: double.infinity,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
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
                                          ? (meal.likes / 1000000).toString() +
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
                  ),
                ]),
              );
            },
          ),
        ));
  }
}
