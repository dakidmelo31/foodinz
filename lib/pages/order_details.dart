import 'dart:io';
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

class OrderDetails extends StatelessWidget {
  final Order order;
  final int total;
  OrderDetails({Key? key, required this.order, required this.total})
      : super(key: key);
  Restaurant? restaurant;
  final pdf = pw.Document();

  Future networkImg() async {
    return await NetworkImage(restaurant!.businessPhoto);
  }

  loadEmojis() async {
    final emoji = await gf.GoogleFonts();
    return emoji;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final restaurantData = Provider.of<RestaurantData>(context, listen: false);
    restaurant = restaurantData.getRestaurant(order.restaurantId);
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
                    for (var i = 0; i < order.prices.length; i++)
                      pw.Padding(
                        padding: pw.EdgeInsets.all(8.0),
                        child: pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              pw.Flexible(
                                child: pw.Row(
                                  children: [
                                    pw.Text(order.names[i] + " X "),
                                    pw.Text(
                                      order.quantities[i].toString(),
                                    ),
                                  ],
                                ),
                              ),
                              pw.Text(
                                NumberFormat().format((order.prices[i] *
                                        order.quantities[i])) +
                                    " CFA",
                              ),
                            ]),
                      ),
                  ],
                ),
                pw.Spacer(),
                pw.Container(
                  margin: pw.EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                  child: pw.Center(
                    child: pw.Padding(
                      padding:
                          pw.EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      padding:
                          pw.EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  margin: pw.EdgeInsets.symmetric(horizontal: 50, vertical: 20),
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
        body: Container(
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 20),
              SizedBox(
                height: kToolbarHeight,
                width: size.width,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                          const Text(
                            "Order Receipt",
                            style: Primary.heading,
                          ),
                          Text(
                              timeAgo.format(
                                order.time.toDate(),
                              ),
                              style: Primary.lightParagraph)
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
              Expanded(
                  child: SizedBox(
                      child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      NumberFormat().format(
                            total,
                          ) +
                          " CFA",
                      style: TextStyle(fontSize: 40, color: Colors.green[400]),
                    ),
                  ),
                ],
              ))),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Container(
                  color: Colors.white,
                  width: size.width,
                  height: size.height * .8,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      SlideUpTween(
                        begin: const Offset(0, 100),
                        child: OpacityTween(
                          child: ClipOval(
                            child: Container(
                              color: order.status.toLowerCase() == "pending"
                                  ? Colors.deepOrange.withOpacity(.2)
                                  : order.status.toLowerCase() == "processing"
                                      ? Colors.blue.withOpacity(.2)
                                      : order.status.toLowerCase() == "takeout"
                                          ? Colors.green.withOpacity(.2)
                                          : order.status.toLowerCase() ==
                                                  "complete"
                                              ? Colors.purple.withOpacity(.2)
                                              : Colors.pink.withOpacity(.2),
                              width: radius + 15,
                              height: radius + 15,
                              child: Align(
                                alignment: Alignment.center,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    maxWidthDiskCache: radius,
                                    maxHeightDiskCache: radius,
                                    imageUrl: restaurant!.businessPhoto,
                                    errorWidget: (_, data, stacktrace) {
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
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          children: [
                            for (var i = 0; i < order.prices.length; i++)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Row(
                                          children: [
                                            Text(order.names[i] + " X "),
                                            Text(
                                              order.quantities[i].toString(),
                                              style: Primary.bigHeading,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        NumberFormat().format((order.prices[i] *
                                                order.quantities[i])) +
                                            " CFA",
                                        style: Primary.heading,
                                      ),
                                    ]),
                              ),
                          ],
                        ),
                      ),
                      order.homeDelivery
                          ? Text("Home Delivery Costs")
                          : Text("No Home delivery"),
                      order.homeDelivery
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Delivery Cost"),
                                Text(
                                  NumberFormat().format(order.deliveryCost) +
                                      " CFA",
                                  style: Primary.heading,
                                ),
                              ],
                            )
                          : Text("Total"),
                      const SizedBox(
                        height: 15,
                      ),
                      Card(
                        color: order.status.toLowerCase() == "pending"
                            ? Colors.pink
                            : Color.fromARGB(255, 113, 49, 253),
                        margin:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                        child: InkWell(
                          onTap: () {
                            debugPrint("move to chat screen");
                            Navigator.push(
                              context,
                              PageTransition(
                                child: ChatScreen(
                                    restaurantId: restaurant!.restaurantId),
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
                                  Text(
                                    "Chat with Shop",
                                    style: Primary.whiteText,
                                  ),
                                  FaIcon(
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
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Color.fromARGB(255, 241, 241, 241),
                                width: 2),
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: InkWell(
                            onTap: () async {
                              debugPrint("Download receipt");
                              await initAwesomeNotification();
                              Directory path =
                                  await getApplicationDocumentsDirectory();
                              String location = join(path.path,
                                  order.friendlyId.toString() + ".pdf");
                              debugPrint("done reading location: $location");
                              final file = File(location);
                              // await file.writeAsBytes(await pdf.save());
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Export receipt",
                                    style: TextStyle(color: Colors.blue[600]),
                                  ),
                                  FaIcon(
                                    FontAwesomeIcons.filePdf,
                                    size: 25,
                                    color: Colors.blue[600],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        margin:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
