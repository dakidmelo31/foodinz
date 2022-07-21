import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodinz/global.dart';
import 'package:foodinz/pages/restaurant_details.dart';
import 'package:foodinz/pages/review_screen.dart';
import 'package:foodinz/providers/data.dart';
import 'package:foodinz/providers/reviews.dart';
import 'package:foodinz/widgets/food_info_table.dart';
import 'package:foodinz/widgets/opacity_tween.dart';
import 'package:foodinz/widgets/transitions.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../models/food.dart';
import '../providers/cart.dart';
import '../providers/meals.dart';
import '../widgets/meal_gallery_slideshow.dart';
import 'review_form.dart';

class FoodDetails extends StatefulWidget {
  const FoodDetails({Key? key, this.myTag, required this.meal})
      : super(key: key);
  final String? myTag;
  final Food meal;

  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails>
    with TickerProviderStateMixin {
  final List<String> _categories = [
    "Breakfast",
    "Lunch",
    "Dinner",
    "Road side",
    "Beef",
    "Dessert",
    "Groceries",
    "Specials",
    "Simple",
    "Traditional",
    "Home Delivery",
    "Vegitarian",
    "Casual",
    "Classic"
  ];

  List<String> _selectedCompliments = [];

  int _counter = 1;
  double selectedStartTime = 0, selectedEndTime = 20;
  String? updateText;
  bool updateCount = true;

  late AnimationController _animationController;
  late Animation<double> _animation;
  final listState = GlobalKey<AnimatedListState>();
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.decelerate);
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final _restaurantData = Provider.of<MealsData>(context, listen: true);
    final Food meal = widget.meal;
    final restaurant = Provider.of<RestaurantData>(context, listen: true)
        .getRestaurant(meal.restaurantId);
    final Size size = MediaQuery.of(context).size;
    final CartData _cart = Provider.of<CartData>(context, listen: false);
    // final cartData = Provider.of<CartData>(context);
    final isAlreadyInCart = _cart.isAvailable(meal.foodId);

    final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);

    if (updateCount) {
      updateCount = false;
      if (isAlreadyInCart != null) {
        debugPrint("is already in cart");
        _counter = isAlreadyInCart.quantity;
      }
    }

    updateCount = false; // prevent counter from reinitializing everytime.
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 25),
              width: size.width,
              height: size.height - kToolbarHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        physics: const BouncingScrollPhysics(
                            parent: const AlwaysScrollableScrollPhysics()),
                        children: [
                          SizedBox(
                              child: Column(children: [
                                OpacityTween(
                                  duration: const Duration(milliseconds: 500),
                                  child: Card(
                                    elevation: 0,
                                    color: Colors.white,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  meal.favorite
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: meal.favorite
                                                      ? Colors.pink
                                                      : Colors.black,
                                                  size: 30,
                                                ),
                                                onPressed: () {
                                                  debugPrint("toggle favorite");
                                                  setState(() {
                                                    _restaurantData.toggleMeal(
                                                        foodId: meal.foodId);
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
                                                  debugPrint(
                                                      "Show review form");
                                                  bool? outcome =
                                                      await Navigator.push(
                                                    context,
                                                    PageTransition(
                                                      alignment:
                                                          Alignment.center,
                                                      child: ReviewForm(
                                                          meal: meal,
                                                          restaurantId: meal
                                                              .restaurantId),
                                                      type: PageTransitionType
                                                          .scale,
                                                      duration: const Duration(
                                                        milliseconds: 1800,
                                                      ),
                                                      curve: Curves.bounceOut,
                                                      fullscreenDialog: true,
                                                      opaque: false,
                                                      reverseDuration:
                                                          const Duration(
                                                        milliseconds: 600,
                                                      ),
                                                    ),
                                                  );

                                                  if (outcome != null) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            duration:
                                                                const Duration(
                                                              milliseconds:
                                                                  1200,
                                                            ),
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                            dismissDirection:
                                                                DismissDirection
                                                                    .down,
                                                            backgroundColor:
                                                                Colors.white,
                                                            elevation: 20,
                                                            width:
                                                                size.width - 70,
                                                            content: Row(
                                                              children: const [
                                                                Text(
                                                                  "Thanks for your review 💖",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ],
                                                            )));
                                                  }
                                                },
                                                label: const Text("Review"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                              height: kToolbarHeight,
                              width: size.width),
                          const SizedBox(height: 10),
                          MealGallery(meal: meal, myTag: widget.myTag),
                          const SizedBox(height: 10),
                          Card(
                            margin: const EdgeInsets.only(top: 15.0),
                            elevation: 15.0,
                            shadowColor: Colors.black.withOpacity(.2),
                            color: Colors.white,
                            child: Center(
                              child: SizedBox(
                                height: 70.0,
                                width: size.width - 15.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: InkWell(
                                    onTap: () {
                                      HapticFeedback.mediumImpact();

                                      Navigator.push(
                                          context,
                                          HorizontalSizeTransition(
                                              child: RestaurantDetails(
                                                  restHero: restaurant.address +
                                                      restaurant.restaurantId +
                                                      restaurant.address,
                                                  restaurant: restaurant)));
                                    },
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  restaurant.companyName,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                Text(
                                                  restaurant.address,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                            width: size.width - 90,
                                          ),
                                          ClipOval(
                                            clipBehavior: Clip.antiAlias,
                                            child: Hero(
                                              tag: restaurant.address +
                                                  restaurant.restaurantId +
                                                  restaurant.address,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    restaurant.businessPhoto,
                                                placeholder: (_, __) =>
                                                    loadingWidget,
                                                errorWidget: (_, __, ___) =>
                                                    errorWidget1,
                                                fit: BoxFit.cover,
                                                alignment: Alignment.center,
                                                height: 70,
                                                width: 60,
                                              ),
                                            ),
                                          )
                                        ]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          OpacityTween(
                            duration: const Duration(milliseconds: 800),
                            child: Hero(
                              tag: widget.myTag! + "name",
                              child: Material(
                                color: Colors.transparent,
                                child: Text(
                                  meal.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          OpacityTween(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                meal.description,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          OpacityTween(
                              child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Choose What to eat with",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16.0),
                                ),
                                Text("(" +
                                    meal.compliments.length.toString() +
                                    ")")
                              ],
                            ),
                          )),
                          SizedBox(
                            width: size.width,
                            height: 80.0,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: meal.compliments.length,
                              physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (_, index) {
                                String compliment = meal.compliments[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: InkWell(
                                    onTap: () {
                                      HapticFeedback.mediumImpact();

                                      if (_selectedCompliments
                                          .contains(compliment)) {
                                        _selectedCompliments.remove(compliment);
                                      } else {
                                        _selectedCompliments.clear();
                                        _selectedCompliments.add(compliment);
                                      }
                                      setState(() {});
                                      debugPrint("clicked");
                                    },
                                    child: AnimatedScale(
                                      duration: Duration(milliseconds: 300),
                                      scale: _selectedCompliments
                                              .contains(compliment)
                                          ? 1.0
                                          : 0.8,
                                      child: AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        opacity: _selectedCompliments
                                                .contains(compliment)
                                            ? 1.0
                                            : 0.6,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 4.0),
                                          child: Chip(
                                            backgroundColor:
                                                _selectedCompliments
                                                        .contains(compliment)
                                                    ? Colors.lightGreen
                                                    : Colors.white,
                                            label: Text(
                                              compliment,
                                              style: TextStyle(
                                                  color: _selectedCompliments
                                                          .contains(compliment)
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                            avatar: Icon(
                                                Icons.food_bank_rounded,
                                                color: _selectedCompliments
                                                        .contains(compliment)
                                                    ? Colors.black
                                                    : Colors.lightGreen),
                                            labelPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 5.0,
                                                    horizontal: 8.0),
                                            elevation: 12.0,
                                            shadowColor:
                                                Colors.black.withOpacity(.4),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Categories",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16.0),
                                    ),
                                    Text("(" +
                                        meal.categories.length.toString() +
                                        ")")
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: size.width,
                                height: 70.0,
                                child: AnimatedList(
                                  initialItemCount: meal.categories.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (_, index, animation) {
                                    String compliment = meal.categories[index];
                                    return AnimatedOpacity(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      opacity:
                                          meal.categories.contains(compliment)
                                              ? 1.0
                                              : 0.3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Chip(
                                          backgroundColor: Colors.white,
                                          label: Text(compliment),
                                          avatar: const Icon(
                                              Icons.food_bank_rounded),
                                          labelPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 5.0,
                                                  horizontal: 8.0),
                                          elevation: 12.0,
                                          shadowColor:
                                              Colors.black.withOpacity(.4),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          OpacityTween(child: FoodInfoTable(meal: meal)),
                          const SizedBox(height: 60),
                          Text("Ingredients"),
                          Column(
                            children: meal.ingredients.map((e) {
                              return ListTile(
                                title: Text(e),
                                trailing: Icon(Icons.check_rounded),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isAlreadyInCart != null
                  ? Row(
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                            _counter =
                                                _counter < 2 ? 1 : _counter - 1;
                                          });
                                          debugPrint(
                                              "update count to $_counter");
                                        }),
                                    Text(
                                      _counter.toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
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
                              HapticFeedback.mediumImpact();

                              setState(() {
                                _cart.updateCart(
                                    item: Cart(
                                        foodId: meal.foodId,
                                        name: meal.name,
                                        image: meal.image,
                                        price: meal.price,
                                        quantity: _counter,
                                        restaurantId: meal.restaurantId));
                              });

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      duration: const Duration(
                                        milliseconds: 1670,
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      dismissDirection: DismissDirection.down,
                                      backgroundColor: Colors.white,
                                      elevation: 20,
                                      width: size.width - 70,
                                      content: Row(
                                        children: [
                                          const Text(
                                            "Cart: ",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          const Spacer(),
                                          Text(
                                            _cart.myCart.length == 1
                                                ? _cart.myCart.length
                                                        .toString() +
                                                    " item"
                                                : _cart.myCart.length
                                                        .toString() +
                                                    " items",
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            " ${NumberFormat().format(meal.price.toInt() * _counter)} CFA",
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
                              child: Hero(
                                tag: widget.myTag! + "price",
                                child: Material(
                                  color: Colors.transparent,
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
                            ),
                          ),
                        )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Material(
                            color: Colors.black.withOpacity(.1),
                            child: SizedBox(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                            _counter =
                                                _counter < 2 ? 1 : _counter - 1;
                                          });
                                        }),
                                    Text(
                                      _counter.toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
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

                              HapticFeedback.mediumImpact();

                              setState(() {
                                _cart.addToCart(Cart(
                                  foodId: meal.foodId,
                                  image: meal.image,
                                  name: meal.name,
                                  price: meal.price,
                                  restaurantId: meal.restaurantId,
                                  compliments: _selectedCompliments,
                                  quantity: _counter,
                                ));
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(
                                    milliseconds: 1550,
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  dismissDirection: DismissDirection.down,
                                  backgroundColor: Colors.white,
                                  elevation: 20,
                                  width: size.width - 70,
                                  content: Row(
                                    children: [
                                      const Text(
                                        "Cart",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      const Spacer(),
                                      Text(
                                        _cart.myCart.length == 1
                                            ? _cart.myCart.length.toString() +
                                                " item"
                                            : _cart.myCart.length.toString() +
                                                " items",
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        " ${NumberFormat().format(meal.price.toInt() * _counter)} CFA",
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                              // Navigator.pop(context, true);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Material(
                                color: Colors.transparent,
                                child: Hero(
                                  tag: widget.myTag! + "price",
                                  child: Text(
                                    "Add to Cart  ${NumberFormat().format(meal.price.toInt())} CFA",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
