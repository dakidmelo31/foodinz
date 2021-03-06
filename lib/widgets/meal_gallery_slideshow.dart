import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodinz/global.dart';
import 'package:foodinz/widgets/food_info_table_item.dart';
import 'package:foodinz/widgets/rating_list.dart';
import 'package:foodinz/widgets/transitions.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../models/food.dart';
import '../themes/light_theme.dart';

class MealGallery extends StatefulWidget {
  const MealGallery({Key? key, this.myTag, required this.meal})
      : super(key: key);
  final String? myTag;
  final Food meal;

  @override
  State<MealGallery> createState() => _MealGalleryState();
}

class _MealGalleryState extends State<MealGallery> {
  late int reviewCount;
  @override
  void initState() {
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
                  Hero(
                    tag: "likes",
                    child: FoodInfoTableItem(
                        description: NumberFormat().format(meal.likes),
                        title: "Likes"),
                  ),
                  const Icon(Icons.favorite_rounded,
                      color: Colors.pink, size: 30),
                ],
              ),
            ),
            Flexible(
              flex: 4,
              child: InkWell(
                onTap: () {
                  HapticFeedback.heavyImpact();

                  Navigator.push(
                    context,
                    VerticalSizeTransition(
                      child: Scaffold(
                        backgroundColor: Colors.black.withOpacity(.6),
                        appBar: AppBar(
                            backgroundColor: Colors.black,
                            title: Hero(
                              tag: widget.myTag! + "name",
                              child: Material(
                                color: Colors.transparent,
                                child: Text(
                                  meal.name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18.0,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                            ),
                            centerTitle: true),
                        body: Center(
                          child: Card(
                            elevation: 0,
                            color: Colors.transparent,
                            child: Hero(
                              tag: widget.myTag!,
                              child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: meal.image,
                                  width: size.width,
                                  height: size.height * .6,
                                  placeholder: (_, __) => loadingWidget,
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
                child: ClipOval(
                  child: Hero(
                    tag: widget.myTag!,
                    child: CachedNetworkImage(
                      placeholder: (_, __) => loadingWidget,
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
                  HapticFeedback.heavyImpact();

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
                      HapticFeedback.heavyImpact();

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
                                          HapticFeedback.heavyImpact();

                                          Navigator.pop(context);
                                        },
                                      ),
                                      backgroundColor: Colors.black,
                                      title: Text(meal.name,
                                          style: Primary.whiteText),
                                      centerTitle: true),
                                  body: Center(
                                    child: Hero(
                                      tag: nextTag,
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: gallery[index],
                                        width: size.width,
                                        height: size.width,
                                        placeholder: (_, __) => loadingWidget,
                                        errorWidget: (_, text, __) {
                                          return Lottie.asset(
                                            "assets/no-connection2.json",
                                          );
                                        },
                                      ),
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
                          placeholder: (_, __) => loadingWidget,
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
