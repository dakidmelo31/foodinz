import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodinz/providers/auth.dart';
import 'package:foodinz/providers/data.dart';
import 'package:foodinz/providers/global_data.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../models/chats_model.dart';
import '../providers/cart.dart';
import '../providers/message_database.dart';
import '../themes/light_theme.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late String start;

  bool homeDelivery = false;
  int deliveryCost = 0;
  @override
  Widget build(BuildContext context) {
    final _cartData = Provider.of<CartData>(context, listen: true);
    deliveryCost = _cartData.myCart.length > 0 && homeDelivery
        ? Provider.of<RestaurantData>(context)
            .selectRestaurant(restaurantId: _cartData.myCart[0].restaurantId)
            .deliveryCost
        : 0;
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.chevron_left,
                size: 40,
              ),
            ),
            title: const Text("Cart", style: TextStyle(fontSize: 20)),
            backgroundColor: const Color.fromARGB(255, 221, 221, 221),
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "${_cartData.myCart.length} Products",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Container(
            width: size.width,
            height: size.height,
            color: const Color.fromARGB(255, 221, 221, 221),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _cartData.myCart.length,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 6),
                    physics: const BouncingScrollPhysics(
                      parent: const AlwaysScrollableScrollPhysics(),
                    ),
                    itemBuilder: (_, index) {
                      Cart item = _cartData.myCart[index];
                      if (index == 0) start = item.restaurantId;

                      return Dismissible(
                        behavior: HitTestBehavior.translucent,
                        direction: DismissDirection.horizontal,
                        movementDuration: const Duration(milliseconds: 350),
                        dragStartBehavior: DragStartBehavior.down,
                        confirmDismiss: (direction) async {
                          _cartData
                              .removeFromCart(item.foodId); // drop from cart
                        },
                        key: GlobalKey(),
                        background: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                              child: const Center(
                                child: Text(
                                  "Remove Item",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              color: Colors.black,
                              height: 70,
                              width: size.width * .9),
                        ),
                        child: Card(
                          color: item.restaurantId != start
                              ? Colors.orange
                              : Colors.white,
                          elevation: 15,
                          shadowColor: Colors.grey.withOpacity(.3),
                          child: Center(
                            child: SizedBox(
                              height: 70,
                              width: double.infinity,
                              child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Hero(
                                        tag: item.image + "33302",
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => Material(
                                                  child: Material(
                                                    child: Center(
                                                      child: Hero(
                                                        tag: item.image +
                                                            "33302",
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: item.image,
                                                          errorWidget: (_,
                                                              error,
                                                              stackTrace) {
                                                            return Material(
                                                              child: Lottie.asset(
                                                                  "assets/no-connection1.json",
                                                                  width: double
                                                                      .infinity,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  fit: BoxFit
                                                                      .cover),
                                                            );
                                                          },
                                                          width:
                                                              double.infinity,
                                                          alignment:
                                                              Alignment.center,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          child: CachedNetworkImage(
                                            imageUrl: item.image,
                                            errorWidget:
                                                (_, error, stackTrace) {
                                              return Lottie.asset(
                                                  "assets/no-connection1.json",
                                                  width: 60,
                                                  height: 70,
                                                  alignment: Alignment.center,
                                                  fit: BoxFit.cover);
                                            },
                                            width: 60,
                                            height: 70,
                                            alignment: Alignment.center,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(item.name,
                                                style: TextStyle(
                                                    color: item.restaurantId ==
                                                            start
                                                        ? Colors.black
                                                        : Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                          ),
                                          Text(item.compliments.join(", "),
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12)),
                                          Text(
                                              item.quantity.toString() +
                                                  " * Unit price " +
                                                  NumberFormat().format(
                                                      (item.price).toInt()) +
                                                  " F",
                                              style: TextStyle(
                                                  color: item.restaurantId ==
                                                          start
                                                      ? Color.fromARGB(
                                                          255, 0, 0, 0)
                                                      : Color.fromARGB(
                                                          255, 0, 0, 0),
                                                  fontSize: 12))
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 4.0),
                                      child: Center(
                                        child: Text(
                                            NumberFormat().format(
                                                    (item.price * item.quantity)
                                                        .toInt()) +
                                                " F",
                                            style: TextStyle(
                                                color:
                                                    item.restaurantId == start
                                                        ? Colors.black
                                                        : Colors.white,
                                                fontSize: 14)),
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height:
                      size.height < 600 ? size.height * .3 : size.height * .25,
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 8.0),
                    child: Column(mainAxisSize: MainAxisSize.max, children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("subTotal"),
                          Text(
                              NumberFormat().format(_cartData.total.toInt()) +
                                  " CFA",
                              style: Primary.heading),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total"),
                          Text(
                              NumberFormat().format(
                                    (deliveryCost + _cartData.total.toInt()),
                                  ) +
                                  " CFA",
                              style: Primary.heading),
                        ],
                      ),
                      SwitchListTile.adaptive(
                          title: const Text("Would you like home delivery?"),
                          subtitle: const Text(
                              "The cost will be added to your bill."),
                          value: homeDelivery,
                          onChanged: (onChanged) {
                            setState(() {
                              debugPrint(deliveryCost.toString());
                              homeDelivery = onChanged;
                            });
                          }),
                      Card(
                        color: Colors.black,
                        elevation: 15,
                        margin:
                            EdgeInsets.symmetric(horizontal: size.width * .2),
                        child: InkWell(
                          onTap: () {
                            if (_cartData.isMultipleRestaurants) {
                              MaterialBanner materialBanner = MaterialBanner(
                                  elevation: 10,
                                  backgroundColor: Colors.deepOrange,
                                  content: const Text(
                                      "You cannot order from multiple restaurants at once.",
                                      style: Primary.whiteText),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .clearMaterialBanners();
                                        },
                                        child: const Text("Ok",
                                            style: Primary.whiteText))
                                  ]);
                              ScaffoldMessenger.of(context)
                                  .showMaterialBanner(materialBanner);
                              Future.delayed(const Duration(seconds: 8), () {
                                ScaffoldMessenger.of(context)
                                    .clearMaterialBanners();
                              }).then((value) => setState(() {}));
                            } else {
                              final restaurant = Provider.of<RestaurantData>(
                                      context,
                                      listen: false)
                                  .getRestaurant(
                                      _cartData.myCart[0].restaurantId);
                              final user =
                                  Provider.of<UserData>(context, listen: false);

                              Chat newChat = Chat(
                                  userId: user.userId ?? "",
                                  lastMessageTime: DateTime.now(),
                                  lastmessage:
                                      "Hi, I'd like to follow up on my order",
                                  restaurantId:
                                      _cartData.myCart[0].restaurantId,
                                  restaurantName: restaurant.companyName,
                                  restaurantImage: restaurant.companyName,
                                  userImage: user.photoURL ?? "",
                                  sender: '',
                                  type: '');

                              // DBManager.instance.addChat(chats: newChat);

                              _cartData.checkout(
                                  isHomeDelivery: homeDelivery,
                                  context: context,
                                  deliveryCost: deliveryCost);
                            }

                            debugPrint("Checkout cart");
                          },
                          child: SizedBox(
                            width: size.width * .6,
                            height: 50,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text("Checkout",
                                    style: TextStyle(color: Colors.white)),
                                FaIcon(FontAwesomeIcons.bagShopping,
                                    color: Colors.white, size: 20)
                              ],
                            ),
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
