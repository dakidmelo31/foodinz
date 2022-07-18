import 'package:flutter/material.dart';
import 'package:foodinz/global.dart';
import 'package:foodinz/models/restaurants.dart';
import 'package:foodinz/providers/data.dart';
import 'package:foodinz/providers/global_data.dart';
import 'package:foodinz/providers/meals.dart';
import 'package:provider/provider.dart';

import '../models/food.dart';

class MyFavorites extends StatefulWidget {
  const MyFavorites({Key? key}) : super(key: key);

  @override
  State<MyFavorites> createState() => _MyFavoritesState();
}

class _MyFavoritesState extends State<MyFavorites>
    with TickerProviderStateMixin {
  final listState2 = GlobalKey<AnimatedListState>();
  final listState1 = GlobalKey<AnimatedListState>();
  late TabController _tabController;
  List<String> foodIds = [], restaurantIds = [];
  bool loading = false;
  loadIds() async {
    setState(() {
      loading = true;
    });
    await getFavoriteMeals();
    restaurantIds = await DBManager.instance.getFollowing();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _favorites = Provider.of<MealsData>(context, listen: true);
    final _restaurants = Provider.of<RestaurantData>(context, listen: true);
    final totalMeals = _favorites.filterMeals(foodIds);
    final totalRestaurants = _restaurants.filterRestaurants(restaurantIds);
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: kToolbarHeight,
              width: size.width,
              child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  enableFeedback: true,
                  tabs: [
                    Tab(
                      child: Text("Meals"),
                    ),
                    Tab(
                      child: Text("Restaurants"),
                    ),
                  ]),
            ),
            Expanded(
                child: TabBarView(
                    controller: _tabController,
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    children: [
                  AnimatedList(
                    key: listState2,
                    initialItemCount: totalMeals.length,
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemBuilder: (_, index, animation) {
                      Food food = totalMeals[index];
                      animation = CurvedAnimation(
                          parent: animation,
                          curve: Curves.fastLinearToSlowEaseIn);

                      return SlideTransition(
                        position: Tween<Offset>(
                                begin: const Offset(0.0, 0.0),
                                end: const Offset(-1.0, 0.0))
                            .animate(animation),
                        child: Container(
                          height: 110.0,
                          width: size.width,
                          alignment: Alignment.center,
                          color: Colors.white,
                          child: Text(
                            food.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedList(
                    key: listState1,
                    initialItemCount: totalRestaurants.length,
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemBuilder: (_, index, animation) {
                      Restaurant restaurant = totalRestaurants[index];
                      animation = CurvedAnimation(
                          parent: animation,
                          curve: Curves.fastLinearToSlowEaseIn);

                      return SlideTransition(
                        position: Tween<Offset>(
                                begin: const Offset(0.0, 0.0),
                                end: const Offset(-1.0, 0.0))
                            .animate(animation),
                        child: Container(
                          height: 110.0,
                          width: size.width,
                          alignment: Alignment.center,
                          color: Colors.white,
                          child: Text(
                            restaurant.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  ),
                ])),
          ],
        ),
      ),
    );
  }
}
