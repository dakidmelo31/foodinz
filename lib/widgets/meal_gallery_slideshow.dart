import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/providers/cart.dart';
import 'package:foodinz/widgets/food_info_table_item.dart';
import 'package:foodinz/widgets/rating_list.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../models/food.dart';
import '../providers/comments_service.dart';

class MealGallery extends StatefulWidget {
  MealGallery({Key? key, required this.meal}) : super(key: key);
  final Food meal;

  @override
  State<MealGallery> createState() => _MealGalleryState();
}

class _MealGalleryState extends State<MealGallery> {
  @override
  Widget build(BuildContext context) {
    final Food meal = widget.meal;
    final _mealComments = Provider.of<CommentsData>(context, listen: true);
    _mealComments.loadAgain ? _mealComments.loadComments(meal.foodId) : null;

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
                      description: meal.likes.toString(), title: "Likes"),
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
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        backgroundColor: Colors.black,
                        appBar: AppBar(
                            title: Text(
                              meal.name,
                            ),
                            centerTitle: true),
                        body: Center(
                          child: Hero(
                            tag: meal.image,
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
                  );
                },
                child: Hero(
                  tag: meal.image,
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
                          child: CommentList(foodId: meal.foodId),
                        );
                      });
                },
                child: Column(
                  children: [
                    FittedBox(
                      child: FoodInfoTableItem(
                          description: _mealComments.comments.length.toString(),
                          title: "Comments"),
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
              return Material(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Scaffold(
                            backgroundColor: Colors.black,
                            appBar: AppBar(
                                title: Text(meal.name), centerTitle: true),
                            body: Hero(
                              tag: gallery[index].toUpperCase() +
                                  (100 + index * 30203).toString(),
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
                          ),
                        ),
                      );
                    },
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
