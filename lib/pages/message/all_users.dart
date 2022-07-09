// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:concentric_transition/page_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodinz/pages/order_details.dart';
import 'package:foodinz/providers/auth.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:foodinz/providers/global_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/global.dart';
import 'package:foodinz/providers/data.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../models/chats_model.dart';
import '../../models/order_model.dart';
import '../../models/restaurants.dart';
import '../custom_messages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.restaurantId}) : super(key: key);
  final String restaurantId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late var _chatStream;
  late var _orderStream;

  List<Order> ordersList = [];
  bool checkId({required String orderId}) {
    bool answer = false;
    for (Order item in ordersList) {
      if (item.orderId == orderId) {
        answer = true;
        break;
      }
    }
    return answer;
  }

  @override
  void initState() {
    timeAgo.setLocaleMessages("en", TimeAgoMessages());
    super.initState();
    _chatStream = firestore
        .collection("messages")
        .where("restaurantId", isEqualTo: widget.restaurantId)
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy("lastMessageTime", descending: false)
        .snapshots();
    _orderStream = firestore
        .collection("orders")
        .where("restaurantId", isEqualTo: widget.restaurantId)
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy("time", descending: false)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final Restaurant restaurant =
        Provider.of<RestaurantData>(context, listen: false)
            .getRestaurant(widget.restaurantId);
    final user = Provider.of<MyData>(context).user;

    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: _orderStream,
                builder: (context, AsyncSnapshot ordersnaps) {
                  if (ordersnaps.hasError) {
                    return Center(
                      child: Text("please log back in"),
                    );
                  }

                  if (ordersnaps.connectionState == ConnectionState.waiting) {
                    return Lottie.asset("assets/loading4.json",
                        width: size.width,
                        height: 80,
                        fit: BoxFit.contain,
                        alignment: Alignment.center);
                  }

                  debugPrint(" total orders: " +
                      ordersnaps.data!.docs.length.toString());
                  for (var doc in ordersnaps.data!.docs) {
                    String documentId = doc.id;

                    debugPrint(documentId);

                    if (!checkId(orderId: documentId)) {
                      var currentOrder = Order(
                        restaurantId: doc['restaurantId'],
                        status: doc["status"] ?? "pending",
                        friendlyId: doc["friendlyId"] ?? 1000,
                        quantities: List<int>.from(doc['quantities']),
                        names: List<String>.from(doc['names']),
                        prices: List<double>.from(doc['prices']),
                        homeDelivery: doc['homeDelivery'] ?? false,
                        deliveryCost: doc['deliveryCost']?.toInt() ?? 0,
                        time: doc["time"],
                        userId: doc['userId'] ?? "no user",
                      );
                      currentOrder.orderId = documentId;
                      ordersList.add(
                        currentOrder,
                      );
                    }

                    // debugPrint(List<String>.from(doc['names']).join(", "));
                  }

                  return SizedBox(
                      width: double.infinity,
                      height: size.height * .155,
                      child: ListView.builder(
                        itemCount: ordersList.length,
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) {
                          final Order order = ordersList[index];
                          int totalCost = 0;

                          for (int i = 0; i < order.prices.length; i++) {
                            var price = order.prices[i];
                            var qty = order.quantities[i];
                            totalCost += (price * qty).toInt();
                          }

                          return Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            elevation: 12,
                            shadowColor: Colors.black.withOpacity(.21),
                            child: InkWell(
                              onTap: () {
                                debugPrint("move to orders");
                                Navigator.push(
                                    context,
                                    ConcentricPageRoute(
                                        builder: (_) => OrderDetails(
                                            order: order, total: totalCost)));

                                // Navigator.push(
                                //   context,
                                //   PageTransition(
                                //     child: OrderDetails(
                                //       order: order,
                                //       total: totalCost,
                                //     ),
                                //     type: PageTransitionType.topToBottom,
                                //     alignment: Alignment.topCenter,
                                //     duration: Duration(milliseconds: 700),
                                //     curve: Curves.decelerate,
                                //   ),
                                // );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                    width: size.width * .4,
                                    height: size.height * .15,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Hero(
                                          tag: order.orderId,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Total"),
                                              ClipOval(
                                                child: Container(
                                                  width: 15,
                                                  height: 15,
                                                  color: order.status
                                                              .toLowerCase() ==
                                                          "pending"
                                                      ? Colors.deepOrange
                                                      : order.status
                                                                  .toLowerCase() ==
                                                              "processing"
                                                          ? Colors.blue
                                                          : order.status
                                                                      .toLowerCase() ==
                                                                  "takeout"
                                                              ? Colors
                                                                  .green[700]
                                                              : order.status
                                                                          .toLowerCase() ==
                                                                      "complete"
                                                                  ? Colors
                                                                      .purple[800]
                                                                  : Colors.pink,
                                                ),
                                              ),
                                              Text(NumberFormat()
                                                      .format(totalCost) +
                                                  " CFA"),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Items"),
                                            Text(order.names.length.toString(),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text("Home Delivery"),
                                            Text("Applied",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Date"),
                                            Text(
                                              timeAgo
                                                  .format(order.time.toDate()),
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                              ),
                            ),
                          );
                        },
                      ));
                }),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _chatStream,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error loading message: " +
                          snapshot.error.toString());
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Lottie.asset(
                        "assets/search-list.json",
                        fit: BoxFit.contain,
                        width: size.width - 100,
                        height: size.width - 100,
                      );
                    }
                    List<DocumentSnapshot<Map<String, dynamic>>> chatMessages =
                        snapshot.data!.docs;
                    var dateTracker;
                    return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: chatMessages
                            .length, // snapshot.data!.docChanges.length,
                        reverse: true,
                        itemBuilder: (_, index) {
                          var map =
                              chatMessages[chatMessages.length - 1 - index];
                          Chat msg = Chat(
                            senderName: user!.name.toString(),
                            opened: map['opened'] ?? true,
                            messageId: map.id,
                            restaurantId: map['restaurantId'],
                            restaurantImage: map['restaurantImage'],
                            restaurantName: map['restaurantName'],
                            userId: map['userId'],
                            sender: map['sender'],
                            userImage: map['userImage'],
                            lastmessage: map['lastmessage'],
                            lastMessageTime:
                                DateTime.fromMillisecondsSinceEpoch(
                                    map['lastMessageTime']),
                          );
                          msg.messageId = map.id;
                          DateTime time = msg.lastMessageTime;
                          bool mergeTimes = false;

                          Duration difference;
                          if (dateTracker == null) {
                            dateTracker = time;
                          } else {
                            difference = dateTracker.difference(time);

                            debugPrint(difference.inMinutes.toString());
                            if (difference.inMinutes <= 1) {
                              mergeTimes = true;
                            }
                            dateTracker = time;
                          }

                          var moment = timeAgo.format(
                            time,
                            allowFromNow: false,
                            clock: DateTime.now(),
                          );

                          return msg.sender == ""
                              ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: restaurant.avatar,
                                            width: size.width * .1,
                                            height: size.width * .1,
                                            errorWidget: (_, __, ___) =>
                                                Lottie.asset(
                                                    "assets/personal-cook.json",
                                                    width: size.width * .1,
                                                    height: size.width * .1,
                                                    fit: BoxFit.cover,
                                                    reverse: true,
                                                    options: LottieOptions(
                                                        enableMergePaths:
                                                            true)),
                                            maxHeightDiskCache: 54,
                                            maxWidthDiskCache:
                                                ((size.width * .1) * 100)
                                                    .ceil(),
                                          ),
                                        ),
                                        SizedBox(
                                            width: size.width * .9,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: SizedBox(
                                                child: Card(
                                                    elevation: 0,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 10),
                                                    color: Color.fromARGB(
                                                        255, 231, 66, 0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Text(
                                                          "this would not seem to be very nice since the day started and you know now how far this would go.",
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      255))),
                                                    )),
                                              ),
                                            )),
                                      ],
                                    ),
                                    if (!mergeTimes)
                                      Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  moment,
                                                  style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(.4),
                                                      fontSize: 12),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0),
                                                  child: ClipOval(
                                                    child: Container(
                                                      width: 5,
                                                      height: 5,
                                                      color: Color.fromARGB(
                                                          255, 157, 101, 255),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0),
                                                  child: Text(
                                                    "You",
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 68, 0, 255),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: size.width * .9,
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: SizedBox(
                                              child: Card(
                                                elevation: 0,
                                                margin: EdgeInsets.only(
                                                    right: 10, top: 10),
                                                color: Color.fromARGB(
                                                    255, 10, 15, 255),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 18.0,
                                                      vertical: 10),
                                                  child: Text(msg.lastmessage,
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (!mergeTimes)
                                      Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  moment,
                                                  style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(.4),
                                                      fontSize: 12),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0),
                                                  child: ClipOval(
                                                    child: Container(
                                                      width: 5,
                                                      height: 5,
                                                      color: Color.fromARGB(
                                                          255, 157, 101, 255),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0),
                                                  child: Text(
                                                    "You",
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 68, 0, 255),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                  ],
                                );
                        });
                  }),
            ),
            TextWidget(restaurantId: widget.restaurantId),
          ],
        ),
      ),
    );
  }
}

class TextWidget extends StatefulWidget {
  const TextWidget({Key? key, required this.restaurantId}) : super(key: key);
  final String restaurantId;

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  late TextEditingController _editingController;

  @override
  void initState() {
    // TODO: implement initState
    _editingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final Restaurant restaurant =
        Provider.of<RestaurantData>(context, listen: false)
            .getRestaurant(widget.restaurantId);
    final user = Provider.of<MyData>(context).user;
    return SizedBox(
      height: kToolbarHeight,
      width: size.width,
      child: Row(
        children: [
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 5,
                        offset: const Offset(0, -2))
                  ]),
              child: TextField(
                controller: _editingController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Message",
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FloatingActionButton(
                onPressed: () async {
                  Chat chat = Chat(
                    opened: false,
                    senderName: user!.name.toString(),
                    lastMessageTime: DateTime.now(),
                    lastmessage: _editingController.text,
                    restaurantId: restaurant.restaurantId,
                    restaurantImage: restaurant.businessPhoto,
                    restaurantName: restaurant.companyName,
                    sender: FirebaseAuth.instance.currentUser!.uid,
                    userId: FirebaseAuth.instance.currentUser!.uid,
                    userImage: "",
                  );
                  if (_editingController.text.isNotEmpty) {
                    sendMessage(chat: chat);
                    _editingController.text = "";
                  } else {
                    debugPrint("no text sent");
                  }
                },
                child: const Icon(
                  Icons.send_outlined,
                  color: Colors.white,
                ),
                elevation: 6),
          ),
        ],
      ),
    );
  }
}
