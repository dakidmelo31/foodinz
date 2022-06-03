import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/pages/all_chats.dart';
import 'package:foodinz/providers/global_data.dart';
import 'package:foodinz/widgets/opacity_tween.dart';
import 'package:foodinz/widgets/restaurant_info_table.dart';
import 'package:foodinz/widgets/slide_up_tween.dart';
import 'package:provider/provider.dart';

import '../models/chats_model.dart';
import '../models/restaurants.dart';
import '../providers/auth.dart';
import '../themes/light_theme.dart';
import '../widgets/food_card.dart';
import '../widgets/promo_code.dart';
import '../widgets/recent_comments.dart';
import '../widgets/today_menu.dart';

class RestaurantDetails extends StatelessWidget {
  const RestaurantDetails({Key? key, required this.restaurant})
      : super(key: key);
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;

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
                  actions: [],
                  floating: true,
                  pinned: false,
                  backgroundColor: Colors.white,
                  expandedHeight: h * .5,
                  flexibleSpace: FlexibleSpaceBar(
                    background: SizedBox(
                      width: w,
                      height: h * .6,
                      child: InkWell(
                        onDoubleTap: () {},
                        child: Hero(
                          tag: restaurant.businessPhoto,
                          child: FoodCard(image: restaurant.businessPhoto),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const Spacer(),
                      Hero(
                        tag: restaurant.restaurantId,
                        child: Material(
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
                                      restaurant: restaurant),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (false)
                        Column(
                          children: [
                            OpacityTween(
                                begin: 0.0,
                                child: SlideUpTween(
                                    begin: const Offset(-30, 30),
                                    child: PromoCode(
                                        restaurantId:
                                            restaurant.restaurantId))),
                          ],
                        ), //meal.averageRating

                      const Spacer(),

                      OpacityTween(
                        child: SlideUpTween(
                          begin: const Offset(-30, 30),
                          child: TodayMenu(
                            restaurantId: restaurant.restaurantId,
                          ),
                        ),
                      ),
                      const Spacer(flex: 5),
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
                            children: [
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
                              lastMessageTime: DateTime.now(),
                              lastmessage: "",
                              restaurantId: restaurant.restaurantId,
                              restaurantImage: restaurant.businessPhoto,
                              restaurantName: restaurant.companyName,
                              sender: currentUser.uid,
                              userId: currentUser.uid,
                              userImage: "",
                            );
                            await DBManager.instance.addChat(chat: chat);
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                    transitionDuration:
                                        Duration(milliseconds: 300),
                                    reverseTransitionDuration:
                                        Duration(milliseconds: 200),
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
                            children: [
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
