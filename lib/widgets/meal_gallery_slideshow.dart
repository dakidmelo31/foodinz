import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/widgets/food_info_table_item.dart';
import 'package:foodinz/widgets/rating_list.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../models/food.dart';
import '../themes/light_theme.dart';

class MealGallery extends StatefulWidget {
  const MealGallery({Key? key, required this.meal, required this.heroTag})
      : super(key: key);
  final Food meal;
  final String heroTag;

  @override
  State<MealGallery> createState() => _MealGalleryState();
}

class _MealGalleryState extends State<MealGallery> {
  late int reviewCount;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Food meal = widget.meal;

    List<String> gallery = meal.gallery;

    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  FoodInfoTableItem(
                      description: NumberFormat().format(meal.likes),
                      title: "Likes"),
                  const Icon(Icons.favorite_rounded,
                      color: Colors.pink, size: 30),
                ],
              ),
            ),
            Flexible(
              flex: 4,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      opaque: false,
                      barrierColor: Colors.transparent,
                      transitionDuration: const Duration(milliseconds: 700),
                      transitionsBuilder:
                          (_, animation, anotherAnimation, child) {
                        return FadeTransition(
                          opacity: CurvedAnimation(
                            parent: animation,
                            curve: Curves.fastOutSlowIn,
                            reverseCurve: Curves.fastLinearToSlowEaseIn,
                          ),
                          child: child,
                        );
                      },
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          Scaffold(
                        backgroundColor: Colors.black,
                        appBar: AppBar(
                            title: Text(
                              meal.name,
                            ),
                            centerTitle: true),
                        body: Center(
                          child: Hero(
                            tag: meal.image,
                            child: Card(
                              elevation: 0,
                              child: CachedNetworkImage(
                                  fit: BoxFit.contain,
                                  imageUrl: meal.image,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorWidget: (_, text, __) {
                                    return Lottie.asset(
                                      "assets/no-connection2.json",
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: widget.heroTag,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: widget.meal.image,
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                      errorWidget: (_, text, __) {
                        return Lottie.asset(
                          "assets/no-connection2.json",
                          width: size.width * .5,
                          height: size.width * .5,
                        );
                      },
                      width: size.width * .5,
                      height: size.width * .5,
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: InkWell(
                onTap: () {
                  showCupertinoModalBottomSheet(
                      duration: const Duration(milliseconds: 600),
                      animationCurve: Curves.bounceIn,
                      bounce: true,
                      enableDrag: true,
                      expand: true,
                      isDismissible: true,
                      topRadius: const Radius.circular(40),
                      context: context,
                      builder: (_) {
                        return SingleChildScrollView(
                          child:
                              CommentList(name: meal.name, foodId: meal.foodId),
                        );
                      });
                },
                child: Column(
                  children: [
                    FittedBox(
                      child: FoodInfoTableItem(
                          description: NumberFormat().format(meal.comments),
                          // snapshot.data!.docs.length.toString(),
                          title: "Reviews"),
                    ),
                    const Icon(Icons.star_rounded,
                        color: Colors.amber, size: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: CarouselSlider.builder(
            itemCount: gallery.length,
            itemBuilder: (_, index, index2) {
              final image = gallery[index];
              final String nextTag =
                  image + (Random().nextDouble() * 99999999999).toString();
              return Material(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              opaque: false,
                              barrierColor: Colors.transparent,
                              transitionDuration:
                                  const Duration(milliseconds: 700),
                              transitionsBuilder:
                                  (_, animation, anotherAnimation, child) {
                                return FadeTransition(
                                  opacity: CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.fastOutSlowIn,
                                    reverseCurve: Curves.fastLinearToSlowEaseIn,
                                  ),
                                  child: child,
                                );
                              },
                              reverseTransitionDuration:
                                  const Duration(milliseconds: 540),
                              pageBuilder: (_, animation, animation2) {
                                return Scaffold(
                                  backgroundColor: Colors.black.withOpacity(.6),
                                  appBar: AppBar(
                                      leading: IconButton(
                                        icon: const Icon(
                                            Icons.arrow_back_rounded,
                                            color: Colors.white),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      backgroundColor: Colors.black,
                                      title: Text(meal.name,
                                          style: Primary.whiteText),
                                      centerTitle: true),
                                  body: Hero(
                                    tag: nextTag,
                                    child: CachedNetworkImage(
                                      fit: BoxFit.contain,
                                      imageUrl: gallery[index],
                                      width: double.infinity,
                                      height: double.infinity,
                                      errorWidget: (_, text, __) {
                                        return Lottie.asset(
                                          "assets/no-connection2.json",
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }));
                    },
                    child: Hero(
                      tag: nextTag,
                      child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: gallery[index],
                          width: size.width * .35,
                          errorWidget: (_, text, __) {
                            return Lottie.asset(
                              "assets/no-connection2.json",
                            );
                          }),
                    ),
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: size.height * .11,
              aspectRatio: 2,
              viewportFraction: .35,
              autoPlay: true,
              enableInfiniteScroll: true,
              enlargeStrategy: CenterPageEnlargeStrategy.scale,
              enlargeCenterPage: true,
            ),
          ),
        ),
      ],
    );
  }
}
