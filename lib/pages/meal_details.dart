import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodinz/global.dart';
import 'package:foodinz/widgets/food_info_table.dart';
import 'package:foodinz/widgets/opacity_tween.dart';
import 'package:foodinz/widgets/scale_tween.dart';
import 'package:foodinz/widgets/slide_up_tween.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../models/food.dart';
import '../providers/auth.dart';
import '../providers/bookmarks.dart';
import '../providers/cart.dart';
import '../providers/meals.dart';
import '../widgets/meal_gallery_slideshow.dart';

class FoodDetails extends StatefulWidget {
  const FoodDetails({Key? key, required this.meal}) : super(key: key);
  final Food meal;

  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails>
    with TickerProviderStateMixin {
                                  TextEditingController _reviewController = TextEditingController();
  int _counter = 1;
  String _dropDownValue = "";
  double selectedStartTime = 0, selectedEndTime = 20;
  String? updateText;
  bool updateCount = true;

  late AnimationController _animationController;
  late Animation<double> _animation;
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
        _animation = CurvedAnimation(parent: _animationController, curve: Curves.decelerate);
        _animationController.forward();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _restaurantData = Provider.of<MealsData>(context);
    final _bookmarksData = Provider.of<BookmarkData>(context, listen: true);
    final _userData = Provider.of<UserData>(context, listen: true);
    final Size size = MediaQuery.of(context).size;
    final Food meal = widget.meal;
    final CartData _cart = Provider.of<CartData>(context, listen: false);
    // final cartData = Provider.of<CartData>(context);
    final isAlreadyInCart = _cart.isAvailable(meal.foodId);
    final currentBookmarkState =
        _bookmarksData.isBookmarked(foodId: meal.foodId);

    if (updateCount) {
      updateCount = false;
      debugPrint("first open");
      if (isAlreadyInCart != null) {
        debugPrint("is already in cart");
        _counter = isAlreadyInCart.quantity;
      }
    }

    updateCount = false; // prevent counter from reinitializing everytime.
    return Scaffold(
      body: AnimatedBuilder(animation: _animation, builder: (_, widget){
        return SizedBox(
        height: size.height,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              height: size.height - kToolbarHeight,
              width: size.width,
              child: Container(
                padding: const EdgeInsets.only(top: 25),
                width: size.width,
                height: size.height - kToolbarHeight,
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
                      OpacityTween(
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.decelerate,
                        child: SlideUpTween(
                          begin: const Offset(0, -100),
                          curve: Curves.decelerate,
                          duration: const Duration(milliseconds: 550),
                          child: MealGallery(meal: meal)),
                      ),
                      const Spacer(),
                      OpacityTween(
                        duration: const Duration(milliseconds: 800),
                        child: Text(
                          meal.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const Spacer(),
                      OpacityTween(
                        child: SlideUpTween(
                        duration: const Duration(milliseconds: 800),
                          begin: const Offset(0, 30),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              meal.description,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      const OpacityTween(child: SlideUpTween(begin: Offset(0, 55),child: Text("Available With Meal"))),
                      OpacityTween(
                        duration: const Duration(milliseconds: 800),
                        child: SlideUpTween(
                          begin: const Offset(100, 0),
                          child: SizedBox(
                            height: 60,
                            width: size.width,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: meal.accessories.length,
                              itemBuilder: (_, index) {
                                final compliment = meal.accessories[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: InkWell(
                                    onTap: () {
                                      debugPrint("show info");
                                      setState(() {
                                        meal.toggle(meal.accessories[index]);
                                      });
                                    },
                                    child: Chip(
                                        backgroundColor:
                                            meal.complimentExists(compliment)
                                                ? Colors.orange
                                                : Colors.grey.withOpacity(.3),
                                        elevation: 10,
                                        label: Text(
                                          compliment,
                                          style: TextStyle(
                                            color: meal.complimentExists(compliment)
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        avatar: const Icon(
                                            Icons.restaurant_menu_rounded,
                                            color: Colors.white)),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      OpacityTween(child: FoodInfoTable(meal: meal)),
                      const Spacer(),
                      DropdownButton(
                        enableFeedback: true,
                        dropdownColor: Colors.black,
                        alignment: Alignment.center,
                        elevation: 10,
                        isDense: true,
                        iconEnabledColor: Colors.deepOrange,
                        hint: _dropDownValue == null
                            ? const Text('Select what to eat with your meal')
                            : Text(
                                _dropDownValue,
                                style: const TextStyle(
                                  color: Colors.orange,
                                ),
                                textAlign: TextAlign.center,
                              ),
                        isExpanded: true,
                        iconSize: 30.0,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                        items: meal.accessories.map(
                          (val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text(val),
                            );
                          },
                        ).toList(),
                        onChanged: (String? val) {},
                      ),
                      const Spacer(),
                      if (isAlreadyInCart != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.delete_forever_rounded,
                                color: Colors.pink,
                                size: 25,
                              ),
                              onPressed: () {
                                debugPrint("drop");
                                setState(() {
                                  _cart.myCart.remove(isAlreadyInCart);
                                });
                              },
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Material(
                                color: Colors.black.withOpacity(.1),
                                child: SizedBox(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                            child: const Text(
                                              "-",
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _counter = _counter < 2
                                                    ? 1
                                                    : _counter - 1;
                                              });
                                              debugPrint(
                                                  "update count to $_counter");
                                            }),
                                        FittedBox(
                                          fit: BoxFit.fill,
                                          child: Text(
                                            _counter.toString(),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          child: const Text(
                                            "+",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _counter++;
                                              debugPrint(
                                                  "update count to $_counter");
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
                                  setState(() {
                                    _cart.updateCart(
                                        item: Cart(
                                            foodId: meal.foodId,
                                            image: meal.image,
                                            price: meal.price,
                                            quantity: _counter,
                                            restaurantId: meal.restaurantId));
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          duration: const Duration(
                                            milliseconds: 1670,
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          dismissDirection:
                                              DismissDirection.down,
                                          backgroundColor: Colors.white,
                                          elevation: 20,
                                          width: size.width - 70,
                                          content: Row(
                                            children: [
                                              const Text(
                                                "Cart: ",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              const Spacer(),
                                              Text(
                                                _cart.myCart.length == 1? _cart.myCart.length.toString() + " item" : _cart.myCart.length.toString() + " items" ,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                "${_cart.total.toInt()} CFA",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          )));
                                  // Navigator.pop(context, true);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    "Update ${NumberFormat().format((isAlreadyInCart.price * isAlreadyInCart.quantity).toInt())} CFA",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                            child: const Text(
                                              "-",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
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
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          child: const Text(
                                            "+",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
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
                                  debugPrint("$_counter");

                                  setState(() {
                                    _cart.addToCart(Cart(
                                      foodId: meal.foodId,
                                      image: meal.image,
                                      price: meal.price,
                                      restaurantId: meal.restaurantId,
                                      compliments: meal.compliments,
                                      quantity: _counter,
                                    ));
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          duration: const Duration(
                                            milliseconds: 1550,
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          dismissDirection:
                                              DismissDirection.down,
                                          backgroundColor: Colors.white,
                                          elevation: 20,
                                          width: size.width - 70,
                                          content: Row(
                                            children: [
                                              const Text(
                                                "Cart",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              const Spacer(),
                                              Text(
                                                _cart.myCart.length == 1? _cart.myCart.length.toString() + " item" : _cart.myCart.length.toString() + " items" ,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                "${_cart.total.toInt()} CFA",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          )));
                                  // Navigator.pop(context, true);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    "Add to Cart  ${meal.price.toInt()} CFA",
                                    style: const TextStyle(
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
                      const Spacer()
                    ],
                  ),
                ),
              ),
            ),
            OpacityTween(
                        duration: const Duration(milliseconds: 700),
              child: SlideUpTween(
                        duration: const Duration(milliseconds: 1200),
                begin: const Offset(0, 80),
                child: Expanded(
                  child: Card(
                    elevation: 0,
                    color: Colors.white,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.keyboard_arrow_left_rounded,
                              size: 30,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              debugPrint("pop");
                              Navigator.maybePop(context);
                            },
                          ),
                          SizedBox(
                              child: Row(children: [
                            Tooltip(
                              margin: const EdgeInsets.only(bottom: 15),
                              message: "bookmark meal",
                              child: IconButton(
                                icon: Icon(
                                  !currentBookmarkState
                                      ? Icons.bookmark_rounded
                                      : Icons.bookmark_border_rounded,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                onPressed: () {
                                  debugPrint("toggle bookmark");
                                  _bookmarksData.toggleBookmark(
                                      foodId: meal.foodId);
                                  debugPrint(_bookmarksData
                                      .isBookmarked(foodId: meal.foodId)
                                      .toString());
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                meal.favorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: meal.favorite ? Colors.pink : Colors.black,
                                size: 30,
                              ),
                              onPressed: () {
                                debugPrint("toggle favorite");
                                setState(() {
                                  _restaurantData.toggleMeal(id: meal.foodId);
                                });
                              },
                            ),
                            TextButton.icon(
                              icon: const Icon(
                                Icons.star_border_rounded,
                                color: Colors.black,
                                size: 30,
                              ),
                              onPressed: () async {
                                debugPrint("Show review form");
                                bool? outcome = await showCupertinoModalBottomSheet(
                                    animationCurve: Curves.bounceIn,
                                    bounce: true,
                                    duration: const Duration(milliseconds: 350),
                                    isDismissible: true,
                                    enableDrag: true,
                                    expand: true,
                                    topRadius: const Radius.circular(30),
                                    context: context,
                                    builder: (_) {
                                      int review = 1;
                                      return StatefulBuilder(
                                        builder: (_, setState) {
                                          return Material(
                                            child: Column(children: [
                                              Flexible(
                                                child: TextField(
                                                  minLines: 8,
                                                  maxLines: 8,
                                                  controller: _reviewController,
                                                  decoration: const InputDecoration(
                                                      label: Text(
                                                          "What do you think about this?"),
                                                      enabled: true,
                                                      fillColor: Colors.white,
                                                      filled: true,
                                                      hintText:
                                                          "Enter your review...",
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15,
                                                              vertical: 10)),
                                                ),
                                              ),
                                              SizedBox(
                                                height: kToolbarHeight,
                                                width: size.width,
                                                child: Center(
                                                  child: InkWell(
                                                    onTap: (){
                                                      HapticFeedback.heavyImpact();
                                                    },
                                                    
                                                    
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                      children:
                                                          [1, 2, 3, 4, 5].map((e) {
                                                        return Padding(
                                                          padding: const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 4.0),
                                                          child: IconButton(
                                                            onPressed: () {
                                                              debugPrint(
                                                                  e.toString());
                                                                  setState(() {
                                                                    review = e;
                                                                  })
                                                            },
                                                            icon: review >= e
                                                                ? const Icon(
                                                                    Icons
                                                                        .star_rounded,
                                                                    color:
                                                                        Colors.amber, 
                                                                         size: 40,
                                                  )
                                                                : const Icon(
                                                                    Icons
                                                                        .star_border_rounded,
                                                                    color:
                                                                        Colors.pink,
                                                                        size: 40,
                                                                  ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const Spacer(flex: 3),
                                              CupertinoButton.filled(
                                                  child: const Text("Add review"),
                                                  onPressed: () {
                                                    debugPrint("add review");
                                                    FirebaseFirestore.instance.collection("reviews").add({
                                                      "restaurantId": meal.restaurantId,
                                                      "foodId": meal.foodId,
                                                      "name": meal.name,
                                                      "image" : meal.image,
                                                      "description": _reviewController.text,
                                                      "userId": _userData.user!.userId,
                                                      "username": _userData.user!.name,
                                                      "avatar": _userData.user!.image,
                                                      "stars": review,
              
                                                      "created_at": FieldValue.serverTimestamp(),
                                                    }).then((value){
                                                      debugPrint("done adding review");
                                                      _reviewController.text = "";
                                                    });
                                                    Navigator.maybePop(
                                                        context, true);
                                                  }),
                                              const Spacer(flex: 1),
                                            ]),
                                          );
                                        },
                                      );
                                    });
              
                                if (outcome != null) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          duration: const Duration(
                                            milliseconds: 1800,
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          dismissDirection: DismissDirection.down,
                                          backgroundColor: Colors.white,
                                          elevation: 20,
                                          width: size.width - 70,
                                          content: Row(
                                            children: [
                                              const Text(
                                                "Thanks for your review 💖",
                                                style:
                                                    TextStyle(color: Colors.black),
                                              ),
                                            ],
                                          )));
                                }
                              },
                              label: const Text("Review"),
                            ),
                          ]))
                        ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      }),
    );
  }
}
