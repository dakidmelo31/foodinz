import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/pages/custom_messages.dart';
import 'package:foodinz/pages/order_details.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import '../models/order_model.dart';
import '../providers/auth.dart';
import '../providers/data.dart';
import '../providers/meals.dart';
import '../theme/main_theme.dart';
import '../themes/light_theme.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({Key? key}) : super(key: key);

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

class _AllOrdersState extends State<AllOrders> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> iconAnimation;
  late List<Order> ordersList;
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
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1250));
    iconAnimation =
        CurvedAnimation(parent: animationController, curve: Curves.bounceInOut);
    timeAgo.setDefaultLocale(
      "en",
    );
    super.initState();
  }

  redo() {
    Future.delayed(
        const Duration(
          seconds: 1250,
        ), () {
      animationController
        ..forward()
        ..reverse().then((value) => redo());
    });
  }

  @override
  Widget build(BuildContext context) {
    ordersList = [];
    final mealsData = Provider.of<MealsData>(context);
    final userData = Provider.of<MyData>(context);
    final _restaurantsData = Provider.of<RestaurantData>(context);

    final meals = mealsData.meals;
    final size = MediaQuery.of(context).size;

    List<String> list = List.generate(20, (index) => faker.lorem.sentence());
    redo();
    return CustomScrollView(
      scrollDirection: Axis.vertical,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              const SizedBox(height: 25),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Hero(
                    tag: "showAll",
                    child: Material(
                        child:
                            const Text("Showing All Orders", style: heading))),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection("orders")
                      .where("userId", isEqualTo: auth.currentUser!.uid)
                      .orderBy("time", descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      debugPrint("error found");
                      return const Text("Error met");
                    } else {
                      debugPrint("no errors");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Lottie.asset(
                        "assets/loading7.json",
                        width: size.width - 160,
                        height: size.width - 160,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      );
                    }

                    debugPrint(" total orders: " +
                        snapshot.data!.docs.length.toString());
                    for (var doc in snapshot.data!.docs) {
                      String documentId = doc.id;

                      debugPrint(documentId);

                      if (!checkId(orderId: documentId)) {
                        var currentOrder = Order(
                          restaurantId: doc['restaurantId'],
                          status: doc["status"] ?? "pending",
                          friendlyId:
                              doc["friendlyId"] ?? Random().nextInt(65000),
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
                      height: size.height - 130,
                      width: size.width,
                      child: ListView.builder(
                          itemCount: ordersList.length,
                          itemBuilder: (_, index) {
                            Order order = ordersList[index];

                            double orderTotal = 0;
                            for (int c = 0; c < order.prices.length; c++) {
                              orderTotal +=
                                  order.prices[c] * order.quantities[c];
                            }
                            orderTotal += order.deliveryCost;
                            return SizedBox(
                              width: size.width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Dismissible(
                                  key: GlobalKey(),
                                  background: Container(
                                      color: Colors.grey.withOpacity(.15),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: AnimatedIcon(
                                            icon: AnimatedIcons.ellipsis_search,
                                            progress: iconAnimation,
                                            size: 30,
                                          ),
                                        ),
                                      )),
                                  behavior: HitTestBehavior.deferToChild,
                                  direction: DismissDirection.endToStart,
                                  secondaryBackground: Container(
                                      color: Colors.deepPurple,
                                      child: const Icon(
                                        Icons.home,
                                        color: Colors.white,
                                      )),
                                  child: InkWell(
                                    splashColor:
                                        const Color.fromARGB(26, 59, 4, 209),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                              transitionDuration:
                                                  Duration(milliseconds: 400),
                                              reverseTransitionDuration:
                                                  Duration(milliseconds: 400),
                                              opaque: true,
                                              barrierColor: Colors.white,
                                              pageBuilder: ((context, animation,
                                                  secondaryAnimation) {
                                                return FadeTransition(
                                                    opacity: animation,
                                                    child: OrderDetails(
                                                      order: order,
                                                      total: orderTotal.toInt(),
                                                    ));
                                              })));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14.0, horizontal: 3),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 12.0),
                                              child: CircleAvatar(
                                                backgroundColor: order.status
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
                                                            ? Colors.green[700]
                                                            : order.status
                                                                        .toLowerCase() ==
                                                                    "complete"
                                                                ? Colors
                                                                    .purple[800]
                                                                : Colors.pink,
                                                child: const Icon(
                                                  Icons.restaurant_menu_rounded,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 0),
                                                    child: Text(
                                                        "#" +
                                                            order.friendlyId
                                                                .toString(),
                                                        style: Primary.heading),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 4.0),
                                                    child: Hero(
                                                      tag: order.friendlyId,
                                                      child: Material(
                                                        child: Text(
                                                          NumberFormat().format(
                                                                  (orderTotal)) +
                                                              " CFA",
                                                          style: TextStyle(
                                                            color: Colors.black
                                                                .withOpacity(
                                                              .9,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                FittedBox(
                                                    child: Hero(
                                                  tag: order.restaurantId
                                                          .toString() +
                                                      order.friendlyId
                                                          .toString(),
                                                  child: Material(
                                                    child: Text(
                                                      timeAgo.format(
                                                        order.time.toDate(),
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                                const SizedBox(height: 5),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: ClipOval(
                                                    child: Hero(
                                                      tag: order.friendlyId
                                                              .toString() +
                                                          "status",
                                                      child: Container(
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
                                                                    ? Colors.green[
                                                                        700]
                                                                    : order.status.toLowerCase() ==
                                                                            "complete"
                                                                        ? Colors.purple[
                                                                            800]
                                                                        : Colors
                                                                            .pink,
                                                        width: 10,
                                                        height: 10,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ]),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  })
            ],
          ),
        ),
      ],
    );
  }
}
