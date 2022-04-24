import 'dart:math';

import 'package:faker/faker.dart' as fk;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodinz/pages/meal_details.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/food.dart';
import '../pages/all_chats.dart';
import '../providers/data.dart';
import '../providers/meals.dart';
import '../theme/main_theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key? key,
    required this.startSearchAnimation,
    required this.endSearchAnimation,
    required this.closeFunction,
  }) : super(key: key);
  final VoidCallback closeFunction;
  final Animation<double> startSearchAnimation;
  final Animation<double> endSearchAnimation;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final faker = fk.Faker();

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<RestaurantData>(context, listen: true);
    final mealData = Provider.of<MealsData>(context, listen: true);

    final Animation<double> startSearchAnimation = widget.startSearchAnimation;
    final Animation<double> endSearchAnimation = widget.endSearchAnimation;
    final colorSwitcher =
        ColorTween(begin: Colors.white.withOpacity(.3), end: Colors.white)
            .animate(widget.endSearchAnimation);
    Size size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: Listenable.merge([startSearchAnimation, endSearchAnimation]),
      builder: (context, child) {
        final w = (endSearchAnimation.value == 0 ? 50 : 0) +
            size.width * startSearchAnimation.value;
        final h = (size.height - 50) * endSearchAnimation.value + (50);
        final rightPosition = -50 * (1 - startSearchAnimation.value);
        final colorSwitcher =
            ColorTween(begin: Colors.white.withOpacity(.3), end: Colors.white)
                .animate(endSearchAnimation);

        final List<Food> searchedList = mealData.searchList;

        return Positioned(
          right: rightPosition,
          top: 0,
          width: w,
          height: h,
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(20 * (1 - endSearchAnimation.value)),
            child: Container(
              width: w,
              height: h,
              color: colorSwitcher.value,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        ClipRRect(
                          child: Container(
                            height: 60,
                            alignment: Alignment.center,
                            width: size.width,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      onPressed: widget.closeFunction,
                                      icon: const FaIcon(
                                          FontAwesomeIcons.arrowLeftLong)),
                                  Flexible(
                                      child: TextField(
                                    onChanged: (value) {
                                      mealData.search(keyword: value);
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Search meals or Restaurant...",
                                      filled: false,
                                    ),
                                  )),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const FaIcon(
                                        FontAwesomeIcons.filterCircleDollar,
                                        color: Colors.black),
                                  ),
                                ]),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: size.width,
                          height: size.height,
                          child: ListView.builder(
                            itemCount: searchedList.length > 20
                                ? 20
                                : searchedList.length,
                            itemBuilder: (_, index) {
                              Food searchItem = searchedList[index];
                              return SizedBox(
                                width: size.width,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Dismissible(
                                    key: GlobalKey(),
                                    background: Container(
                                        color: const Color.fromARGB(
                                            255, 43, 146, 39),
                                        child: const Icon(
                                          Icons.home,
                                          color: Colors.white,
                                        )),
                                    behavior: HitTestBehavior.deferToChild,
                                    direction: DismissDirection.horizontal,
                                    secondaryBackground: Container(
                                        color: Colors.deepPurple,
                                        child: const Icon(
                                          Icons.home,
                                          color: Colors.white,
                                        )),
                                    child: InkWell(
                                      splashColor:
                                          const Color.fromARGB(26, 59, 4, 209),
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        debugPrint("showDetails");
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration: const Duration(
                                                milliseconds: 400),
                                            reverseTransitionDuration:
                                                const Duration(
                                                    milliseconds: 400),
                                            opaque: false,
                                            pageBuilder: (_,
                                                _animationController,
                                                secondary) {
                                              return FadeTransition(
                                                opacity: _animationController,
                                                child: FoodDetails(
                                                    meal: searchItem),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14.0, horizontal: 3),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 12.0),
                                                child: CircleAvatar(
                                                  backgroundColor: Random()
                                                          .nextBool()
                                                      ? Colors.deepPurple
                                                      : Random().nextBool()
                                                          ? Colors.blue
                                                          : Random().nextBool()
                                                              ? Colors.orange
                                                              : Random()
                                                                      .nextBool()
                                                                  ? Colors.pink
                                                                  : Colors.grey,
                                                  child: Icon(
                                                    Random().nextBool()
                                                        ? Icons
                                                            .supervised_user_circle
                                                        : Icons.chair_rounded,
                                                    color: Random().nextBool()
                                                        ? Colors.black
                                                        : Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8.0,
                                                          horizontal: 0),
                                                      child: Text(
                                                          searchItem.name,
                                                          style: heading),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 4.0),
                                                      child: Text(
                                                        searchItem.description,
                                                        style: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(
                                                            .8,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  FittedBox(
                                                      child: Text(
                                                          NumberFormat().format(
                                                                  searchItem
                                                                      .price
                                                                      .toInt()) +
                                                              " CFA",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))),
                                                ],
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
