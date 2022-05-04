import 'dart:math';
import 'package:timeago/timeago.dart' as timeAgo;

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodinz/global.dart';
import 'package:foodinz/providers/data.dart';
import 'package:foodinz/providers/message_database.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/message.dart';
import '../models/message_data.dart';
import '../models/order_model.dart';
import '../models/restaurants.dart';
import '../widgets/message_tile.dart';
import '../widgets/order_details.dart';
import '../widgets/order_dialog.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.restaurantId}) : super(key: key);
  final String restaurantId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<Widget> mixedList;
  late List<Order> ordersList;
  late List<Message> messageList;
  TextEditingController _editingController = TextEditingController();
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
  Widget build(BuildContext context) {
    mixedList = [];
    messageList = [];
    ordersList = [];
    final Restaurant restaurant =
        Provider.of<RestaurantData>(context).getRestaurant(widget.restaurantId);
    final orders = firestore.collection("orders").get();

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.maybePop(context);
            },
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white)),
        actions: [
          IconButton(
            color: Colors.amber,
            onPressed: () {},
            icon: const FaIcon(FontAwesomeIcons.ellipsisVertical),
          )
        ],
        centerTitle: true,
        title: Text(restaurant.companyName,
            style: const TextStyle(color: Colors.white)),
        elevation: 10,
        shadowColor: Colors.white,
        backgroundColor: const Color(0xFF101D42),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(.15),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: firestore.collection("orders").snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> ordersSnapshot) {
                  return FutureBuilder<List<Message>>(
                      future: DatabaseHelper.instance
                          .getMessages(senderId: restaurant.restaurantId),
                      builder: (context, messagesSnapshot) {
                        if (messagesSnapshot.hasError) {
                          return const Text(
                              "Error, please logout and signing again");
                        }
                        //collecting Orders
                        firestore
                            .collection("orders")
                            .where("restaurantId",
                                isEqualTo: restaurant.restaurantId)
                            .where("userId", isEqualTo: auth.currentUser!.uid)
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          for (var doc in querySnapshot.docs) {
                            String documentId = doc.id;
                            debugPrint(documentId);
                            if (!checkId(orderId: documentId)) {
                              ordersList.add(
                                Order(
                                  friendlyId: doc["friendlyId"] ??
                                      Random().nextInt(65000),
                                  restaurantId: doc['restaurantId'],
                                  status: doc["status"] ?? "pending",
                                  quantities: List<int>.from(doc['quantities']),
                                  names: List<String>.from(doc['names']),
                                  prices: List<double>.from(doc['prices']),
                                  homeDelivery: doc['homeDelivery'] ?? false,
                                  deliveryCost:
                                      doc['deliveryCost']?.toInt() ?? 0,
                                  time: doc["time"],
                                  userId: doc['userId'] ?? "no user",
                                ),
                              );
                            }

                            debugPrint(
                                List<String>.from(doc['names']).join(", "));
                          }
                          debugPrint(ordersList.length.toString());
                        });

                        if (ordersSnapshot.hasError ||
                            messagesSnapshot.hasError) {
                          debugPrint("error found");
                          return const Text("Error met");
                        } else {
                          debugPrint("no errors");
                        }
                        if (ordersSnapshot.connectionState ==
                                ConnectionState.waiting &&
                            messagesSnapshot == ConnectionState.waiting) {
                          return Lottie.asset(
                            "assets/loading6.json",
                            width: size.width - 150,
                            height: 150,
                            alignment: Alignment.center,
                            fit: BoxFit.contain,
                          );
                        }
                        var orderWidgets = ordersList.map<Widget>(((e) {
                          return OpenContainer(
                            openBuilder: (_, __) =>
                                OrderDetails(orderId: e.orderId),
                            closedBuilder: (_, openContainer) => Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 25),
                              elevation: 15,
                              child: InkWell(
                                onTap: openContainer,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 30),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ClipOval(
                                            child: Container(
                                              width: 15,
                                              height: 15,
                                              color: Colors.pink,
                                            ),
                                          ),
                                          Text("New order"),
                                          Text(
                                            timeAgo.format(e.time.toDate()),
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        e.names.join(
                                          ", ",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        })).toList();

                        return Expanded(
                          child: ListView.builder(
                            reverse: true,
                            itemCount: orderWidgets.length,
                            itemBuilder: (_, index) {
                              return orderWidgets[index];
                            },
                          ),
                        );
                      });
                }),
            Container(
              width: size.width,
              height: size.height * .13,
              color: Colors.grey.withOpacity(.15),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: TextField(
                            controller: _editingController,
                            decoration: InputDecoration(
                              prefix: IconButton(
                                  icon: const FaIcon(
                                    FontAwesomeIcons.faceSmileWink,
                                  ),
                                  onPressed: () {
                                    ;
                                  }),
                              hintText: "Message",
                              filled: true,
                              fillColor: Colors.white,
                              border: const OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  borderSide: BorderSide.none),
                            ),
                            maxLines: 2,
                            minLines: 1,
                          ),
                        ),
                        FloatingActionButton.small(
                          onPressed: () {},
                          child: const Icon(Icons.send),
                        )
                      ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
