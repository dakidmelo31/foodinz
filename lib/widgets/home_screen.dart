import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/widgets/searh_page.dart';
import 'package:foodinz/widgets/street_restaurants.dart';
import 'package:provider/provider.dart';

import '../pages/recommended_screen.dart';
import '../providers/auth.dart';
import '../providers/data.dart';
import '../providers/meals.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  reload() {
    setState(() {});
  }

  late AnimationController _searchController;

  bool search = false;

  late final TabController _tabController;
  late Animation<double> verticalExpand;
  late Animation<double> horizontalExpand;

  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      vsync: this,
      animationDuration: const Duration(milliseconds: 350),
    );
    _searchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 760),
    );
    horizontalExpand = CurvedAnimation(
        parent: _searchController,
        curve: const Interval(0.0, 0.50, curve: Curves.easeInOut));
    verticalExpand = CurvedAnimation(
        parent: _searchController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<RestaurantData>(context, listen: true);
    final mealData = Provider.of<MealsData>(context, listen: true);
    final user = Provider.of<UserData>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.requestFocus();
        },
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              width: size.width,
              height: size.height,
              child: TabBarView(
                dragStartBehavior: DragStartBehavior.down,
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  Showcase(searchFunction: () {
                    setState(() {
                      // search = true;
                      _searchController.forward();
                    });
                  }),
                  StreetRestaurantsScreen(),
                  StreetRestaurantsScreen(),
                ],
              ),
            ),
            // if (search)
            SearchScreen(
                startSearchAnimation: horizontalExpand,
                endSearchAnimation: verticalExpand,
                closeFunction: () {
                  _searchController.reverse();
                })
          ],
        ),
      ),
    );
  }
}
