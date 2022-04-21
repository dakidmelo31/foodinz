import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/providers/bookmarks.dart';
import 'package:foodinz/widgets/food_info_table.dart';
import 'package:foodinz/widgets/meal_gallery_slideshow.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import '../models/food.dart';
import '../providers/cart.dart';
import 'slide_up_tween.dart';

class MealBottomSheet extends StatefulWidget {
  const MealBottomSheet({Key? key, required this.meal}) : super(key: key);
  final Food meal;

  @override
  State<MealBottomSheet> createState() => _MealBottomSheetState();
}

class _MealBottomSheetState extends State<MealBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Food meal = widget.meal;
    int _counter = 1;
    final cartData = Provider.of<CartData>(context);
    final isAlreadyInCart = cartData.isAvailable(meal.foodId);
    _counter = isAlreadyInCart != null ? isAlreadyInCart.quantity : 1;
    String? _dropDownValue;
    final bookMark = Provider.of<BookmarkData>(context, listen: true);
    final alreadyBookmarked = bookMark.isBookmarked(foodId: meal.foodId);
    double selectedStartTime = 0, selectedEndTime = 20;
    String? updateText;
    return StatefulBuilder(builder: (context, setState) {
      return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 65),
                  child: Container(
                    width: 80,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: size.width,
                    height: size.height * .9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        children: [
                          const Spacer(),
                          MealGallery(meal: meal),
                          const Spacer(),
                          Text(
                            meal.name,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            meal.description,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Spacer(),
                          ExpansionTile(
                            leading: Icon(Icons.restaurant_menu),
                            expandedAlignment: Alignment.center,
                            title: Text("Categories "),
                            children: meal.categories
                                .map((e) => Text(e,
                                    style: TextStyle(color: Colors.orange)))
                                .toList(),
                          ),
                          const Spacer(),
                          FoodInfoTable(meal: meal),
                          const Spacer(),
                          DropdownButton(
                            enableFeedback: true,
                            dropdownColor: Colors.black,
                            alignment: Alignment.center,
                            elevation: 10,
                            isDense: true,
                            iconEnabledColor: Colors.deepOrange,
                            hint: _dropDownValue == null
                                ? Text('Select what to eat with your meal')
                                : Text(
                                    _dropDownValue!,
                                    style: TextStyle(
                                      color: Colors.orange,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                            isExpanded: true,
                            iconSize: 30.0,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                            items: meal.accessories.map(
                              (val) {
                                return DropdownMenuItem<String>(
                                  value: val,
                                  child: Text(val),
                                );
                              },
                            ).toList(),
                            onChanged: (String? val) {
                              setState(
                                () {
                                  _dropDownValue = val.toString();
                                },
                              );
                            },
                          ),
                          TextButton.icon(
                            onPressed: () {
                              bookMark.isBookmarked(foodId: meal.foodId)
                                  ? setState(() {
                                      bookMark.removeBookmark(meal.foodId);
                                    })
                                  : setState(() {
                                      bookMark.addBookmark(meal.foodId);
                                    });
                            },
                            icon: Icon(
                              !bookMark.isBookmarked(foodId: meal.foodId)
                                  ? Icons.bookmark_border_rounded
                                  : Icons.bookmark_rounded,
                              size: 30,
                              color: Colors.black,
                            ),
                            label: Text(
                              "Add to Bookmark",
                            ),
                          ),
                          const Spacer(),
                          SlideUpTween(
                            curve: Curves.bounceInOut,
                            duration: Duration(milliseconds: 350),
                            begin: Offset(130, 0),
                            child: SizedBox(
                                height: 100,
                                width: size.width,
                                child: Slider.adaptive(
                                    label: selectedStartTime == 0.0
                                        ? "Now"
                                        : "${selectedStartTime.toInt()} mins",
                                    min: 0,
                                    max: 120,
                                    value: selectedStartTime,
                                    onChanged: (onChanged) {
                                      setState(() {
                                        selectedStartTime = onChanged;
                                      });
                                    })),
                          ),
                          const Spacer(),
                          isAlreadyInCart != null
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Material(
                                        color: Colors.black.withOpacity(.1),
                                        child: SizedBox(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextButton(
                                                    child: Text(
                                                      "-",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _counter = _counter < 2
                                                            ? 1
                                                            : _counter - 1;
                                                      });
                                                    }),
                                                FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: Text(
                                                    _counter.toString(),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  child: Text(
                                                    "+",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      _counter = _counter + 1;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                            height: 50,
                                            width: 150),
                                      ),
                                    ),
                                    Card(
                                      color: Colors.black,
                                      child: InkWell(
                                        onTap: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  duration: Duration(
                                                    milliseconds: 1800,
                                                  ),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  dismissDirection:
                                                      DismissDirection.down,
                                                  backgroundColor: Colors.white,
                                                  elevation: 20,
                                                  width: size.width - 70,
                                                  content: Row(
                                                    children: [
                                                      Text(
                                                        "Cart",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        cartData.myCart.length
                                                                .toString() +
                                                            " items",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        "${cartData.total} CFA",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  )));
                                          Navigator.pop(context, true);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Text(
                                            "Update Cart  ${isAlreadyInCart.price * isAlreadyInCart.quantity} CFA",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Material(
                                        color: Colors.black.withOpacity(.1),
                                        child: SizedBox(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextButton(
                                                    child: Text(
                                                      "-",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _counter = _counter < 2
                                                            ? 1
                                                            : _counter - 1;
                                                      });
                                                    }),
                                                FittedBox(
                                                  child: Text(
                                                    _counter.toString(),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  child: Text(
                                                    "+",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      _counter = _counter + 1;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                            height: 50,
                                            width: 150),
                                      ),
                                    ),
                                    Card(
                                      color: Colors.black,
                                      child: InkWell(
                                        onTap: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  duration: Duration(
                                                    milliseconds: 1800,
                                                  ),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  dismissDirection:
                                                      DismissDirection.down,
                                                  backgroundColor: Colors.white,
                                                  elevation: 20,
                                                  width: size.width - 70,
                                                  content: Row(
                                                    children: [
                                                      Text(
                                                        "Cart",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        cartData.myCart.length
                                                                .toString() +
                                                            " items",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        "${cartData.total} CFA",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  )));
                                          cartData.addToCart(Cart(
                                            foodId: meal.foodId,
                                            image: meal.image,
                                            price: meal.price,
                                            restaurantId: meal.restaurantId,
                                            quantity: _counter,
                                          ));
                                          Navigator.pop(context, true);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Text(
                                            "Add to Cart  ${meal.price} CFA",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ));
    });
  }
}
