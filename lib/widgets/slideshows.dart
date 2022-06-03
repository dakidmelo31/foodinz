import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/providers/meals.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/food.dart';

class ShowcaseSlideshow extends StatefulWidget {
  const ShowcaseSlideshow({Key? key}) : super(key: key);

  @override
  State<ShowcaseSlideshow> createState() => _ShowcaseSlideshowState();
}

class _ShowcaseSlideshowState extends State<ShowcaseSlideshow> {
  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    _pageController = PageController(viewportFraction: .6, keepPage: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _meals = Provider.of<MealsData>(context);
    List<Food> meals = _meals.meals;
    meals.sort(((a, b) => a.gallery.length.compareTo(b.gallery.length)));

    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      height: size.height * .26,
      width: size.width,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.2),
              offset: Offset(0, 6),
              blurRadius: 2,
              blurStyle: BlurStyle.outer,
              spreadRadius: 2,
            ),
          ],
          gradient: LinearGradient(colors: [
            Colors.white,
            Color.fromARGB(255, 241, 241, 241),
            Colors.white,
          ], end: Alignment.bottomRight, begin: Alignment.topLeft),
        ),
        child: Stack(alignment: Alignment.center, children: [
          Positioned(
            left: 0,
            width: size.width * .3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Remember to Drop reviews on your favorite meals.",
                  style: TextStyle(fontSize: 14)),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            width: size.width * .7,
            child: Lottie.asset("assets/order.json",
                width: double.infinity,
                reverse: true,
                options: LottieOptions(enableMergePaths: true),
                fit: BoxFit.contain),
            height: size.height * .26,
          )
        ]),
      ),
    );
  }
}
