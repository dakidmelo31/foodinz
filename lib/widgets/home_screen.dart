import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/pages/loading_page.dart';
import 'package:foodinz/pages/restaurants_screen.dart';
import 'package:foodinz/widgets/dot_indicator_painter.dart';
import 'package:foodinz/widgets/opacity_tween.dart';
import 'package:foodinz/widgets/slide_up_tween.dart';
import 'package:foodinz/widgets/street_restaurants.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/food.dart';
import '../pages/recommended_screen.dart';
import '../providers/data.dart';
import '../providers/meals.dart';
import 'cafe_restaurants.dart';
import 'classic_restaurants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  reload() {
    setState(() {});
  }

  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 5,
      vsync: this,
      animationDuration: const Duration(milliseconds: 350),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<RestaurantData>(context, listen: true);
    final mealData = Provider.of<MealsData>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: TabBarView(
            dragStartBehavior: DragStartBehavior.down,
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
          RecommendedScreen(),
          ClassicRestaurantsScreen(),
          CafeRestaurantsScreen(),
          OpacityTween(
            child: SlideUpTween(
                duration: Duration(milliseconds: 500),
                curve: Curves.elasticInOut,
                begin: Offset(-100, 0),
                child: RestaurantsScreen()),
          ),
          StreetRestaurantsScreen(),
        ]));
  }
}
