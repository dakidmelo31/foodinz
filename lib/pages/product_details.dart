import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/food.dart';
import '../providers/cart.dart';
import '../widgets/meal_gallery_slideshow.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key, required this.heroTag, required this.meal})
      : super(key: key);
  final Food meal;
  final String heroTag;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _mainAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 550),
    );
    _mainAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInBack);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Food meal = widget.meal;
    int _counter = 1;
    final cartData = Provider.of<CartData>(context);
    final isAlreadyInCart = cartData.isAvailable(meal.foodId);
    _counter = isAlreadyInCart != null ? isAlreadyInCart.quantity : 1;
    String? _dropDownValue;
    double selectedStartTime = 0, selectedEndTime = 20;
    String? updateText;
    _animationController.forward();

    return Scaffold(
        body: Stack(
      children: [
        AnimatedBuilder(
            animation: _mainAnimation,
            builder: (_, child) {
              final topPosition =
                  (1 - _mainAnimation.value) * (size.height / 2);
              return Positioned(
                top: topPosition,
                width: size.width,
                height: size.height,
                child: Opacity(
                  opacity: _mainAnimation.value.clamp(0.0, 1.0),
                  child: SizedBox(
                    child: Column(children: [
                      SizedBox(
                        height: kToolbarHeight,
                        width: size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back_rounded,
                                    color: Colors.black),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.restaurant_menu,
                                    size: 30, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: size.height * .4,
                        width: size.width,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MealGallery(meal: meal),
                            Text(
                              meal.name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
                  ),
                ),
              );
            }),
      ],
    ));
  }
}
