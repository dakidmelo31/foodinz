import 'package:faker/faker.dart' as fk;
import 'package:flutter/material.dart';
import 'package:foodinz/widgets/search_card.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../models/food.dart';
import '../models/search.dart';
import '../providers/data.dart';
import '../providers/meals.dart';
import '../providers/message_database.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  late DatabaseHelper dbManager;
  TextEditingController _searchController = TextEditingController();

  late AnimationController _animationController;
  late final Animation<double> startSearchAnimation;
  late final Animation<double> endSearchAnimation;
  bool openSearch = true;

  startDBM() async {
    dbManager = DatabaseHelper.instance;
  }

  List<Food> searchedItems = [];

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    startSearchAnimation = CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.fastLinearToSlowEaseIn));
    endSearchAnimation = CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn));
    _animationController.forward();
    startDBM();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<RestaurantData>(context, listen: true);
    final recentSearches = Provider.of<DatabaseHelper>(context, listen: true);
    List<Search> searchHistory = [];

    final mealData = Provider.of<MealsData>(context, listen: true);

    final colorSwitcher =
        ColorTween(begin: Colors.white.withOpacity(.3), end: Colors.white)
            .animate(endSearchAnimation);
    Size size = MediaQuery.of(context).size;

    return Material(
      child: SafeArea(
        child: CupertinoScaffold(
          topRadius: const Radius.circular(15),
          body: Container(
            color: Colors.white,
            width: size.width,
            height: size.height,
            child: Column(
              children: [
                if (openSearch)
                  Card(
                    shadowColor: Colors.grey.withOpacity(.5),
                    child: SizedBox(
                      height: kToolbarHeight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          IconButton(
                              onPressed: () {
                                // Navigator.pop(context);
                                setState(() {
                                  openSearch = !openSearch;
                                });
                              },
                              icon: const Icon(Icons.arrow_back_rounded)),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onEditingComplete: () {
                                if (_searchController.text.isNotEmpty)
                                  mealData.search(
                                      keyword: _searchController.text);
                                recentSearches.addSearch(
                                    keyword: _searchController.text);
                                setState(() {
                                  openSearch = !openSearch;
                                });
                              },
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  filled: false,
                                  hintText: "Search"),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                // Navigator.pop(context);
                                setState(() {
                                  _searchController.text = "";
                                });
                              },
                              icon: const Icon(Icons.close_rounded)),
                        ],
                      ),
                    ),
                  ),
                if (!openSearch)
                  InkWell(
                    onTap: () => setState(() {
                      openSearch = !openSearch;
                    }),
                    child: AppBar(
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: () {
                          if (mealData.searchList.isNotEmpty) {
                            setState(() {
                              mealData.searchList.clear();
                            });
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      backgroundColor: Colors.white,
                      elevation: 0,
                      title: Text(
                        _searchController.text.isEmpty
                            ? "Search"
                            : _searchController.text,
                        style: const TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 16),
                      ),
                      actions: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                openSearch = !openSearch;
                              });
                            },
                            icon: const Icon(Icons.search_rounded)),
                      ],
                    ),
                  ),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                          color: Colors.white,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            itemCount: mealData.searchList.length,
                            itemBuilder: (_, index) {
                              var item = mealData.searchList[index];
                              var restaurant =
                                  data.getRestaurant(item.restaurantId);
                              bool isExpanded = true;

                              return SearchCard(
                                  food: item, restaurant: restaurant);
                            },
                          )),
                      if (openSearch)
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (_, child) {
                            _animationController.forward();
                            return FadeTransition(
                              opacity: _animationController,
                              child: child,
                            );
                          },
                          child: Container(
                            color: Colors.white,
                            child: FutureBuilder<List<Search>>(
                                future: recentSearches.getRecentSearches(),
                                builder: (context,
                                    AsyncSnapshot<List<Search>> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text(
                                        "Error found: ${snapshot.error}");
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Lottie.asset(
                                        "assets/waiting-pigeon.json",
                                        fit: BoxFit.contain);
                                  }

                                  return ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (_, index) {
                                      Search search = snapshot.data![index];

                                      return ListTile(
                                          onTap: () => _searchController.text =
                                              search.keyword,
                                          title: Text(
                                            search.keyword,
                                            style: const TextStyle(
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                          leading: IconButton(
                                              icon: const Icon(Icons.close),
                                              onPressed: () {
                                                debugPrint("id is " +
                                                    search.id.toString());
                                                recentSearches.removeSearch(
                                                    keyword: search.keyword);
                                                setState(() {});
                                              }),
                                          trailing:
                                              const Icon(Icons.manage_search));
                                    },
                                  );
                                }),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
