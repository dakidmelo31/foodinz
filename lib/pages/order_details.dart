import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:foodinz/global.dart';
import 'package:foodinz/local_notif.dart';
import 'package:google_fonts/google_fonts.dart' as gf;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodinz/models/restaurants.dart';
import 'package:foodinz/pages/all_chats.dart';
import 'package:foodinz/providers/data.dart';
import 'package:foodinz/widgets/opacity_tween.dart';
import 'package:foodinz/widgets/slide_up_tween.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import '../models/order_model.dart';
import '../themes/light_theme.dart';

class OrderDetails extends StatefulWidget {
  final Order order;
  final int total;
  OrderDetails({Key? key, required this.order, required this.total})
      : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails>
    with TickerProviderStateMixin {
  Restaurant? restaurant;

  final pdf = pw.Document();

  Future networkImg() async {
    return await NetworkImage(restaurant!.businessPhoto);
  }

  loadEmojis() async {
    final emoji = await gf.GoogleFonts();
    return emoji;
  }

  late final AnimationController _animationController;
  late Animation<double> earlyAnimation, lateAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1300));
    earlyAnimation = CurvedAnimation(
        parent: _animationController,
        curve: const Interval(.0, .5, curve: Curves.elasticInOut));
    lateAnimation = CurvedAnimation(
        parent: _animationController, curve: Curves.elasticInOut);
    _animationController.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final restaurantData = Provider.of<RestaurantData>(context, listen: false);
    restaurant = restaurantData.getRestaurant(widget.order.restaurantId);
    if (restaurant == null) {
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.pink,
            margin: const EdgeInsets.only(bottom: 50, left: 10, right: 10),
            content: const Text(
              "This ticket is not valid.",
              style: Primary.whiteText,
              textAlign: TextAlign.center,
            ),
            elevation: 15,
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.symmetric(vertical: 15),
          ),
        );
      });
    }
    int radius = 30;
    setState(() {});
    final networkImage = networkImg();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.letter,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.SizedBox(height: 10),
                pw.Text(
                  restaurant!.companyName,
                ),
                pw.Text(restaurant!.address),
                pw.Spacer(),
                pw.Text(
                  "Order details",
                ),
                pw.Spacer(),
                pw.Column(
                  children: [
                    for (var i = 0; i < widget.order.prices.length; i++)
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              pw.Flexible(
                                child: pw.Row(
                                  children: [
                                    pw.Text(widget.order.names[i] + " X "),
                                    pw.Text(
                                      widget.order.quantities[i].toString(),
                                    ),
                                  ],
                                ),
                              ),
                              pw.Text(
                                NumberFormat().format((widget.order.prices[i] *
                                        widget.order.quantities[i])) +
                                    " CFA",
                              ),
                            ]),
                      ),
                  ],
                ),
                pw.Spacer(),
                pw.Container(
                  margin: const pw.EdgeInsets.symmetric(
                      horizontal: 50, vertical: 5),
                  child: pw.Center(
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                        children: [
                          pw.Text(
                            "Chat with Shop",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                pw.Container(
                  decoration: pw.BoxDecoration(
                      border: pw.Border.all(width: 2),
                      borderRadius: pw.BorderRadius.circular(15)),
                  child: pw.Center(
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                        children: [
                          pw.Text(
                            "Chat with Shop",
                          ),
                        ],
                      ),
                    ),
                  ),
                  margin: const pw.EdgeInsets.symmetric(
                      horizontal: 50, vertical: 20),
                )
              ],
            ),
          );
        },
      ),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 239, 239, 239),
        body: AnimatedBuilder(
            animation: earlyAnimation,
            child: Container(
              width: size.width,
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 20),
                  SlideUpTween(
                    curve: Curves.bounceIn,
                    begin: const Offset(0, 100),
                    child: SizedBox(
                      height: kToolbarHeight,
                      width: size.width,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.maybePop(context);
                                },
                                icon: const Icon(Icons.chevron_left_rounded),
                                iconSize: 30,
                                color: Colors.black,
                              ),
                            ),
                            Column(
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    "Order Receipt",
                                    style: Primary.heading,
                                  ),
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: Text(
                                      timeAgo.format(
                                        widget.order.time.toDate(),
                                      ),
                                      style: Primary.lightParagraph),
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: IconButton(
                                onPressed: () {},
                                color: Colors.black,
                                icon: const Icon(
                                  Icons.ios_share_rounded,
                                ),
                                iconSize: 30,
                              ),
                            )
                          ]),
                    ),
                  ),
                  Expanded(
                      child: SizedBox(
                          child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: OpacityTween(
                          duration: const Duration(milliseconds: 700),
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              NumberFormat().format(
                                    widget.total,
                                  ) +
                                  " CFA",
                              style: TextStyle(
                                  fontSize: size.height * .04,
                                  color:
                                      const Color.fromARGB(255, 40, 1, 214)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))),
                  OpacityTween(
                    duration: const Duration(milliseconds: 900),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      child: Container(
                        color: Colors.white,
                        width: size.width,
                        height: size.height < 610
                            ? size.height * .7
                            : size.height * .8,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            SlideUpTween(
                              curve: Curves.elasticIn,
                              begin: const Offset(0, 100),
                              child: OpacityTween(
                                child: ClipOval(
                                  child: Container(
                                    color: widget.order.status
                                                .toLowerCase() ==
                                            "pending"
                                        ? Colors.deepOrange.withOpacity(.2)
                                        : widget.order.status.toLowerCase() ==
                                                "processing"
                                            ? Colors.blue.withOpacity(.2)
                                            : widget.order.status
                                                        .toLowerCase() ==
                                                    "takeout"
                                                ? Colors.green.withOpacity(.2)
                                                : widget.order.status
                                                            .toLowerCase() ==
                                                        "complete"
                                                    ? Colors.purple
                                                        .withOpacity(.2)
                                                    : Colors.pink
                                                        .withOpacity(.2),
                                    width: radius + 15,
                                    height: radius + 15,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: ClipOval(
                                        child: Material(
                                          color: Colors.transparent,
                                          child: CachedNetworkImage(
                                            maxWidthDiskCache: radius,
                                            maxHeightDiskCache: radius,
                                            imageUrl:
                                                restaurant!.businessPhoto,
                                            errorWidget:
                                                (_, data, stacktrace) {
                                              return Lottie.asset(
                                                  "assets/no-connection2.json",
                                                  reverse: true);
                                            },
                                            width: radius.toDouble(),
                                            height: radius.toDouble(),
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              restaurant!.companyName,
                              style: Primary.heading,
                            ),
                            Text(restaurant!.address),
                            const SizedBox(height: 20),
                            const Text(
                              "Order details",
                              style: Primary.heading,
                            ),
                            Expanded(
                              child: ListView(
                                physics: const BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics()),
                                children: [
                                  for (var i = 0;
                                      i < widget.order.prices.length;
                                      i++)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  widget.order.quantities[i]
                                                          .toString() +
                                                      " . ",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Colors.blueAccent),
                                                ),
                                                SizedBox(
                                                  width: size.width * .55,
                                                  child: Text(
                                                    widget.order.names[i],
                                                    style: const TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              NumberFormat().format(
                                                      (widget.order.prices[i] *
                                                          widget.order
                                                              .quantities[i])) +
                                                  " CFA",
                                              style: Primary.heading,
                                            ),
                                          ]),
                                    ),
                                ],
                              ),
                            ),
                            widget.order.homeDelivery
                                ? const Text("Home Delivery Costs")
                                : const Text("No Home delivery"),
                            widget.order.homeDelivery
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text("Delivery Cost"),
                                      Text(
                                        NumberFormat().format(
                                                widget.order.deliveryCost) +
                                            " CFA",
                                        style: Primary.heading,
                                      ),
                                    ],
                                  )
                                : const Text("Total"),
                            const SizedBox(
                              height: 15,
                            ),
                            Card(
                              color:
                                  widget.order.status.toLowerCase() == "pending"
                                      ? const Color.fromARGB(255, 40, 1, 214)
                                      : const Color.fromARGB(255, 113, 49, 253),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 5),
                              child: InkWell(
                                onTap: () {
                                  debugPrint("move to chat screen");
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: ChatScreen(
                                          restaurantId:
                                              restaurant!.restaurantId),
                                      type: PageTransitionType.bottomToTop,
                                    ),
                                  );
                                },
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Text(
                                          "Chat with Shop",
                                          style: Primary.whiteText,
                                        ),
                                        const FaIcon(
                                          FontAwesomeIcons.solidMessage,
                                          color: Colors.white,
                                          size: 25,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (widget.order.status.toLowerCase() == "pending")
                              Card(
                                color: Colors.white,
                                elevation: 15,
                                shadowColor: Colors.grey.withOpacity(.5),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 5),
                                child: InkWell(
                                  onLongPress: () async {
                                    HapticFeedback.heavyImpact();
                                    debugPrint("Cancelling order");
                                    bool outcome =
                                        await showCupertinoModalPopup(
                                            context: context,
                                            builder: (builder) {
                                              return Center(
                                                child: Card(
                                                  color: Colors.white,
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 40),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10,
                                                                vertical: 40),
                                                        child: const Text(
                                                            "This will alert the business to stop processing your order."),
                                                      ),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        height: 60,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context,
                                                                    true);
                                                              },
                                                              child: const Text(
                                                                  "Confirm "),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context,
                                                                    false);
                                                              },
                                                              child: const Text(
                                                                "Keep Order",
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });

                                    if (outcome) {
                                      debugPrint(widget.order.orderId);
                                      firestore
                                          .collection("orders")
                                          .doc(widget.order.orderId)
                                          .set({"status": "cancelled"},
                                              SetOptions(merge: true)).then(
                                        (value) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  "You just cancelled this order.",
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                              backgroundColor: Colors.amber,
                                            ),
                                          );
                                          Navigator.pop(context);
                                        },
                                      );
                                    }
                                  },
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Center(
                                            child: const Text(
                                              "Hold to Cancel Order",
                                              style: Primary.lightParagraph,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            builder: (context, snapshot) {
              return FadeTransition(
                opacity: earlyAnimation,
                child: snapshot,
              );
            }),
      ),
    );
  }
}
