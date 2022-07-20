import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/global.dart';
import 'package:foodinz/models/restaurants.dart';
import 'package:foodinz/pages/meal_details.dart';
import 'package:foodinz/pages/restaurant_details.dart';
import 'package:foodinz/providers/data.dart';
import 'package:foodinz/providers/global_data.dart';
import 'package:foodinz/providers/meals.dart';
import 'package:foodinz/widgets/transitions.dart';
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
  late final AnimationController _animationController;

  bool loading = false;
  loadIds() async {
    setState(() {
      loading = true;
    });
    foodIds = await getFavoriteMeals();
    restaurantIds = await getFavoriteRestaurants();

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 800,
      ),
    );
    loadIds();
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
        child: AnimatedBuilder(
            animation: _animationController,
            builder: (_, animation) {
              return Scaffold(
                body: Column(
                  children: [
                    SizedBox(
                      height: kToolbarHeight,
                      width: size.width,
                      child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          enableFeedback: true,
                          tabs: const [
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
                              debugPrint(food.name);

                              return Dismissible(
                                key: GlobalKey(),
                                background: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 28.0),
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.delete_forever,
                                            color: Colors.pink,
                                          ),
                                          Text("Remove")
                                        ],
                                      ),
                                    )),
                                child: Card(
                                  elevation: 10.0,
                                  shadowColor: Colors.black.withOpacity(.25),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 10),
                                  child: ListTile(
                                    title: Text(
                                      food.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: CachedNetworkImage(
                                          imageUrl: food.image,
                                          width: 60,
                                          height: 60,
                                          alignment: Alignment.center,
                                          fit: BoxFit.cover,
                                          errorWidget: (_, __, ___) =>
                                              errorWidget1,
                                          placeholder: (_, __) =>
                                              loadingWidget),
                                    ),
                                    dense: true,
                                    enableFeedback: true,
                                    minVerticalPadding: 10,
                                    subtitle: Text(
                                      "With: " + food.categories.join(", "),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          VerticalSizeTransition(
                                              child: FoodDetails(meal: food)));
                                    },
                                    trailing: IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.close_rounded,
                                            color: Colors.pink)),
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

                              return Dismissible(
                                key: GlobalKey(),
                                background: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 28.0),
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.delete_forever,
                                            color: Colors.pink,
                                          ),
                                          Text("Remove")
                                        ],
                                      ),
                                    )),
                                child: Card(
                                  elevation: 10.0,
                                  shadowColor: Colors.black.withOpacity(.25),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 10),
                                  child: ListTile(
                                    title: Text(
                                      restaurant.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: CachedNetworkImage(
                                          imageUrl: restaurant.businessPhoto,
                                          width: 60,
                                          height: 60,
                                          alignment: Alignment.center,
                                          fit: BoxFit.cover,
                                          errorWidget: (_, __, ___) =>
                                              errorWidget1,
                                          placeholder: (_, __) =>
                                              loadingWidget),
                                    ),
                                    dense: true,
                                    enableFeedback: true,
                                    minVerticalPadding: 10,
                                    subtitle: Text(
                                      "With: " +
                                          restaurant.categories.join(", "),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          VerticalSizeTransition(
                                              child: RestaurantDetails(
                                            restaurant: restaurant,
                                          )));
                                    },
                                    trailing: IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.close_rounded,
                                            color: Colors.pink)),
                                  ),
                                ),
                              );
                            },
                          ),
                        ])),
                  ],
                ),
              );
            }));
  }
}
