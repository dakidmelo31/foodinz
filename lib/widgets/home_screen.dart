import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/pages/loading_page.dart';
import 'package:foodinz/pages/restaurants_screen.dart';
import 'package:foodinz/widgets/dot_indicator_painter.dart';
import 'package:foodinz/widgets/opacity_tween.dart';
import 'package:foodinz/widgets/slide_up_tween.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/food.dart';
import '../pages/recommended_screen.dart';
import '../providers/data.dart';
import '../providers/meals.dart';

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
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          title:
              const Text("Food!n City", style: TextStyle(color: Colors.orange)),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                debugPrint("Search bar");
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30.0),
            child: TabBar(
              controller: _tabController,
              indicator: DotIndicator(),
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelColor: Colors.grey.withOpacity(0.6),
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              indicatorColor: Colors.deepOrange,
              tabs: const [
                Tab(
                  child: Text("Recommendation"),
                ),
                Tab(
                  child: Text("Classic"),
                ),
                Tab(
                  child: Text("Cafe"),
                ),
                Tab(
                  child: Text("Restaurant"),
                ),
                Tab(
                  child: Text("Street Food"),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(controller: _tabController, children: [
          RecommendedScreen(),
          SizedBox.expand(),
          SizedBox.expand(),
          OpacityTween(
            child: SlideUpTween(
                duration: Duration(milliseconds: 500),
                curve: Curves.elasticInOut,
                begin: Offset(-100, 0),
                child: RestaurantsScreen()),
          ),
          SizedBox.expand(),
        ]));
  }
}
