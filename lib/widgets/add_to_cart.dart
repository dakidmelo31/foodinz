import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/widgets/slide_up_tween.dart';

import 'food_selection.dart';

class AddToCart extends StatelessWidget {
  const AddToCart({Key? key, required this.foodId, required this.restaurantId})
      : super(key: key);

  final String foodId, restaurantId;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CupertinoButton.filled(
      child: const Text("Add To Cart"),
      onPressed: () async {
        const transitionDuration = Duration(milliseconds: 200);
        await showModalBottomSheet(
                elevation: 20,
                enableDrag: true,
                barrierColor: Colors.black.withOpacity(0.6),
                isDismissible: true,
                useRootNavigator: true,
                context: context,
                builder: (BuildContext context) {
                  int? _counter = 1;
                  int selectedTime = 0;
                  double newPadding = 40;

                  return StatefulBuilder(builder: (_, StateSetter setState) {
                    return Container(
                        width: size.width,
                        height: size.height * .35,
                        child: Column(
                          children: [
                            const Spacer(
                              flex: 1,
                            ),
                            const Text(
                              "When do you want your order?",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                            SlideUpTween(
                              curve: Curves.bounceInOut,
                              duration: const Duration(milliseconds: 350),
                              begin: const Offset(130, 0),
                              child: SizedBox(
                                height: 100,
                                width: size.width,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: 6,
                                    itemBuilder: (_, index) {
                                      newPadding == 6
                                          ? null
                                          : Future.delayed(
                                              const Duration(
                                                milliseconds: 200,
                                              ), () {
                                              debugPrint("loop?");
                                              setState(() {
                                                newPadding = 6;
                                              });
                                            });
                                      return SlideUpTween(
                                        begin: const Offset(-130, 0),
                                        duration:
                                            const Duration(milliseconds: 1250),
                                        curve: Curves.bounceIn,
                                        child: AnimatedPadding(
                                          duration:
                                              const Duration(milliseconds: 550),
                                          curve: Curves.easeInToLinear,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: newPadding,
                                              vertical: 10),
                                          child: Card(
                                            color: index == selectedTime
                                                ? Colors.blue
                                                : Colors.white,
                                            shadowColor:
                                                Colors.grey.withOpacity(.3),
                                            elevation: 15,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedTime = index;
                                                });
                                              },
                                              child: SizedBox(
                                                height: 80,
                                                width: 70,
                                                child: Center(
                                                  child: Text(
                                                      index == 0
                                                          ? "Now"
                                                          : "${index * 10} mins",
                                                      style: TextStyle(
                                                        color: index !=
                                                                selectedTime
                                                            ? Colors.blue
                                                            : Colors.white,
                                                      )),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Flexible(
                                  flex: 3,
                                  child: Text("Quantity"),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Material(
                                    color: Colors.black,
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
                                                    color: Colors.white,
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _counter = _counter! < 2
                                                        ? 1
                                                        : _counter! - 1;
                                                  });
                                                }),
                                            FittedBox(
                                              child: Text(
                                                _counter.toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              child: const Text(
                                                "+",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _counter = _counter! + 1;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        height: 50,
                                        width: 150),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                            CupertinoButton.filled(
                                borderRadius: BorderRadius.circular(30),
                                child: const Text("Add to Cart"),
                                onPressed: () {
                                  debugPrint("show this");
                                  Navigator.pop(context, true);
                                }),
                            const SizedBox(height: 20)
                          ],
                        ));
                  });
                })
            ? Navigator.of(context).push(
                PageRouteBuilder(
                  fullscreenDialog: true,
                  transitionDuration: transitionDuration,
                  reverseTransitionDuration: transitionDuration,
                  pageBuilder: (_, animation, __) {
                    return FadeTransition(
                      opacity: animation,
                      child: FoodSelection(foodId: foodId),
                    );
                  },
                ),
              )
            : null;
      },
    );
  }
}
