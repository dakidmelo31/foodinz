import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/pages/street_food_details.dart';
import 'package:lottie/lottie.dart';

import '../themes/light_theme.dart';

class StreetFood extends StatelessWidget {
  const StreetFood({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrl = "";
    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.orange.withOpacity(.13),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text("Tasty Street Food", style: Primary.heading),
            ),
          ),
          SizedBox(
              width: size.width,
              height: size.height > 650 ? size.height * .35 : size.height * .45,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                physics: BouncingScrollPhysics(
                  parent: const AlwaysScrollableScrollPhysics(),
                ),
                scrollDirection: Axis.horizontal,
                itemCount: 25,
                itemBuilder: (_, index) {
                  int rating = Random().nextInt(12);
                  List<Widget> ratings = [];
                  for (int i = 0; i < 5; i++) {
                    if (i < rating) {
                      ratings.add(
                        Icon(Icons.star_rounded, color: Colors.amber),
                      );
                    } else {
                      ratings.add(
                        Icon(Icons.star_rounded,
                            color: Colors.grey.withOpacity(.3)),
                      );
                    }
                  }
                  imageUrl = Random().nextBool()
                      ? "https://media.istockphoto.com/photos/greek-gyros-picture-id942444674?b=1&k=20&m=942444674&s=170667a&w=0&h=8H6IKLj6ojIg-sts5P8WqnqvdOjX3hAiQmUqHw0MXYE="
                      : Random().nextBool()
                          ? "https://images.unsplash.com/photo-1644615988562-31d2e98fb6b7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8c2hhd2FybWF8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60"
                          : Random().nextBool()
                              ? "https://images.unsplash.com/photo-1530469912745-a215c6b256ea?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8c2hhd2FybWF8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60"
                              : "https://images.unsplash.com/photo-1642783944285-b33b18ef6c3b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8c2hhd2FybWF8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60";
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    height: double.infinity,
                    width: size.width / 2.4,
                    child: Column(
                      children: [
                        Spacer(),
                        ClipOval(
                          child: Hero(
                            tag: imageUrl,
                            child: GestureDetector(
                              onTap: () {
                                debugPrint("open new page");
                                const Duration transitionDuration =
                                    Duration(milliseconds: 300);
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: transitionDuration,
                                      reverseTransitionDuration:
                                          transitionDuration,
                                      barrierDismissible: true,
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return ScaleTransition(
                                          scale: animation,
                                          child: StreedFoodDetails(
                                              restaurantId: imageUrl),
                                          alignment: Alignment.bottomCenter,
                                          filterQuality: FilterQuality.high,
                                        );
                                      },
                                    ));
                              },
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                alignment: Alignment.center,
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high,
                                errorWidget: (_, string, stackTrace) {
                                  return Lottie.asset(
                                      "assets/no-connection2.json");
                                },
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        Text(
                          Random().nextBool()
                              ? "Shawarma"
                              : Random().nextBool()
                                  ? "Burning Fish"
                                  : "Morning Achombo",
                          style: Primary.paragraph,
                        ),
                        Spacer(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: ratings),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                Random().nextBool()
                                    ? "Molyko"
                                    : Random().nextBool()
                                        ? "Buea Town"
                                        : Random().nextBool()
                                            ? "Clerks Quarters"
                                            : Random().nextBool()
                                                ? "Sandpit"
                                                : Random().nextBool()
                                                    ? "Mile 17"
                                                    : "Check Point",
                                style: Primary.paragraph,
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.location_pin,
                                    color: Colors.pink,
                                  ),
                                  onPressed: () {
                                    debugPrint("Open map");
                                  }),
                            ],
                          ),
                        ),
                        Spacer(),
                        Text(
                          Random().nextBool()
                              ? "Bakari's Shawarma Station"
                              : Random().nextBool()
                                  ? "Sweet Shawarma Station"
                                  : Random().nextBool()
                                      ? "High Quality Shawarma"
                                      : Random().nextBool()
                                          ? "Buy Heavy Quality Shawarma"
                                          : Random().nextBool()
                                              ? "J & J Shawarma shop"
                                              : "Shawarma Hotspot with Extra Meat",
                          style: Primary.shawarmaHeading,
                        ),
                        Spacer(),
                      ],
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }
}
