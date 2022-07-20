import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodinz/pages/all_chats.dart';
import 'package:foodinz/providers/global_data.dart';
import 'package:foodinz/widgets/opacity_tween.dart';
import 'package:foodinz/widgets/restaurant_info_table.dart';
import 'package:foodinz/widgets/slide_up_tween.dart';
import 'package:provider/provider.dart';
import '../global.dart';
import '../models/chats_model.dart';
import '../models/restaurants.dart';
import '../providers/auth.dart';
import '../themes/light_theme.dart';
import '../widgets/food_card.dart';
import '../widgets/other_details.dart';
import '../widgets/promo_code.dart';
import '../widgets/today_menu.dart';

class RestaurantDetails extends StatefulWidget {
  const RestaurantDetails({Key? key, required this.restaurant, this.restHero})
      : super(key: key);
  final Restaurant restaurant;
  final String? restHero;

  @override
  State<RestaurantDetails> createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
  bool following = false;

  initiateCheck() async {
    following = await checkFollow(restaurantId: widget.restaurant.restaurantId);
    debugPrint("done loading follow status: $following");
    setState(() {});
  }

  @override
  void initState() {
    initiateCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;
    final user = Provider.of<MyData>(context, listen: false).user;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  floating: true,
                  pinned: false,
                  backgroundColor: Colors.white,
                  expandedHeight: h * .5,
                  flexibleSpace: FlexibleSpaceBar(
                    background: SizedBox(
                      width: w,
                      height: h * .6,
                      child: InkWell(
                        onDoubleTap: () {
                          debugPrint("pressed");
                        },
                        child: FoodCard(image: widget.restaurant.businessPhoto),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Card(
                        color: Colors.white,
                        elevation: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text("Followers"),
                                  Text(
                                    widget.restaurant.followers.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                reverseDuration:
                                    const Duration(milliseconds: 400),
                                transitionBuilder: (child, animation) {
                                  return ScaleTransition(
                                    alignment: Alignment.center,
                                    filterQuality: FilterQuality.high,
                                    scale: CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.fastLinearToSlowEaseIn,
                                        reverseCurve:
                                            Curves.fastLinearToSlowEaseIn),
                                    child: child,
                                  );
                                },
                                child: following
                                    ? DecoratedBox(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.pink,
                                            width: 2.0,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                        child: Card(
                                          elevation: .0,
                                          color: Colors.white,
                                          child: SizedBox(
                                            width: 190.0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: InkWell(
                                                onTap: () async {
                                                  HapticFeedback.heavyImpact();

                                                  bool outcome =
                                                      await showCupertinoDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (_) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  "Unsubscribe from merchant"),
                                                              content:
                                                                  const Text(
                                                                "You will stop receiving notifications from this merchant",
                                                                maxLines: 2,
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context,
                                                                          true);
                                                                    },
                                                                    child: const Text(
                                                                        "Unsubscribe")),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context,
                                                                          false);
                                                                    },
                                                                    child: const Text(
                                                                        "Cancel")),
                                                              ],
                                                            );
                                                          });
                                                  if (!outcome) {
                                                    return;
                                                  }
                                                  setState(() {
                                                    if (following) {
                                                      widget.restaurant
                                                          .followers--;
                                                    } else {
                                                      widget.restaurant
                                                          .followers++;
                                                    }
                                                  });
                                                  setState(() {
                                                    following = !following;
                                                  });
                                                  await toggleLocalFollow(
                                                      restaurantId: widget
                                                          .restaurant
                                                          .restaurantId);
                                                  setState(() {});
                                                },
                                                child: Center(
                                                    child: Row(
                                                  children: const [
                                                    Icon(
                                                        Icons.vibration_rounded,
                                                        color: Colors.pink),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "Now following",
                                                      style: TextStyle(
                                                          color: Colors.pink),
                                                    ),
                                                  ],
                                                )),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Card(
                                        elevation: 15.0,
                                        color: Colors.pink,
                                        child: InkWell(
                                          onTap: () async {
                                            HapticFeedback.heavyImpact();
                                            setState(() {
                                              if (following) {
                                                widget.restaurant.followers--;
                                              } else {
                                                widget.restaurant.followers++;
                                              }
                                            });
                                            setState(() {
                                              following = !following;
                                            });
                                            await toggleLocalFollow(
                                                restaurantId: widget
                                                    .restaurant.restaurantId);
                                            setState(() {});
                                          },
                                          child: SizedBox(
                                            width: 190.0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Center(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: const [
                                                  Icon(
                                                    Icons
                                                        .notification_add_rounded,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "Follow for Updates",
                                                    style: Primary.whiteText,
                                                  ),
                                                ],
                                              )),
                                            ),
                                          ),
                                        ),
                                      ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Card(
                              color: Colors.white,
                              elevation: 15,
                              shadowColor: Colors.grey.withOpacity(.25),
                              margin: EdgeInsets.symmetric(
                                horizontal: w * 0.03,
                                vertical: 10,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.1,
                                  vertical: 10,
                                ),
                                child: RestaurantInfoTable(
                                    restaurant: widget.restaurant),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (false)
                        Column(
                          children: [
                            OpacityTween(
                                begin: 0.0,
                                child: SlideUpTween(
                                    begin: const Offset(-30, 30),
                                    child: PromoCode(
                                        restaurantId:
                                            widget.restaurant.restaurantId))),
                          ],
                        ), //meal.averageRating

                      OpacityTween(
                        child: SlideUpTween(
                          begin: const Offset(-30, 30),
                          child: TodayMenu(
                            restaurantId: widget.restaurant.restaurantId,
                          ),
                        ),
                      ),
                      OtherDetails(restaurant: widget.restaurant)
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: size.width,
            height: kToolbarHeight,
            color: Colors.white,
            child: Card(
              margin: EdgeInsets.zero,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Card(
                      color: Colors.white,
                      elevation: 10,
                      shadowColor: Colors.grey.withOpacity(.12),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 9),
                          child: Row(
                            children: const [
                              Icon(Icons.arrow_back_rounded,
                                  color: Colors.black),
                              Material(
                                  color: Colors.transparent,
                                  child: Text("Back")),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      color: Colors.black,
                      child: InkWell(
                        onTap: () async {
                          var currentUser = FirebaseAuth.instance.currentUser;
                          if (currentUser != null) {
                            Chat chat = Chat(
                              opened: false,
                              senderName: user.name.toString(),
                              lastMessageTime: DateTime.now(),
                              lastmessage: "",
                              restaurantId: widget.restaurant.restaurantId,
                              restaurantImage: widget.restaurant.businessPhoto,
                              restaurantName: widget.restaurant.companyName,
                              sender: currentUser.uid,
                              userId: currentUser.uid,
                              userImage: "",
                            );
                            await DBManager.instance.addChat(chat: chat);
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 300),
                                    reverseTransitionDuration:
                                        const Duration(milliseconds: 200),
                                    pageBuilder:
                                        (_, animation, secondaryAnimation) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: ChatScreen(
                                            restaurantId: chat.restaurantId),
                                      );
                                    }));
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 9),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.message_rounded,
                              ),
                              Text(
                                "Tap to message business",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
