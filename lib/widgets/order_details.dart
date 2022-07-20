import 'package:cached_network_image/cached_network_image.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:timeago/timeago.dart' as timeAgo;

import '../themes/light_theme.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({Key? key, required this.orderId}) : super(key: key);
  final String orderId;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final faker = Faker();
    bool more = false;
    final List<String> menu = ["1", "3", "4", "5", " 6"];
    List<String> subMenu = [];
    if (menu.length > 2) {
      int counter = 0;
      for (String item in menu) {
        if (counter > 2) {
          more = true;
          break;
        } else {
          subMenu.add(item);
          counter++;
        }
      }
    } else {
      subMenu = menu;
    }
    return Scaffold(
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: Column(
                children: [
                  const Spacer(),
                  const Text(
                    "Order Details",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const Spacer(),
                  Material(
                    elevation: 20,
                    shadowColor: Colors.grey.withOpacity(.3),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 18.0, horizontal: 18.0),
                        child: QrImage(
                          data: orderId,
                          backgroundColor: Colors.white,
                          constrainErrorBounds: true,
                          errorCorrectionLevel: QrErrorCorrectLevel.M,
                          gapless: true,
                          size: 130,
                          version: 3,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Column(
                    children: subMenu.map((e) {
                      String imageUrl = faker.image
                          .image(random: true, width: 80, height: 80);
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    width: 32,
                                    height: 32,
                                    imageUrl: imageUrl,
                                    alignment: Alignment.center,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Text(faker.lorem.sentence(),
                                  style: const TextStyle(),
                                  overflow: TextOverflow.ellipsis),
                            ),
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Row(
                                children: [
                                  const Align(
                                    alignment: Alignment.centerRight,
                                    child: const Text(
                                      "3 x 500 CFA",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  if (more)
                    Text(
                        "+" +
                            (menu.length - subMenu.length == 0
                                    ? 1
                                    : menu.length - subMenu.length)
                                .toString() +
                            " more",
                        style: Primary.lightParagraph),
                  const Spacer(),
                  const Divider(
                    height: 12,
                    color: Colors.pink,
                    endIndent: 70,
                    thickness: 1,
                    indent: 70,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Date", style: Primary.heading),
                        Text(
                          timeAgo.format(
                            DateTime.now().subtract(
                              const Duration(
                                hours: 5033,
                              ),
                            ),
                          ),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Quantity", style: Primary.heading),
                        const Text(
                          "5",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Status", style: Primary.heading),
                        const Text(
                          "Pending",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  CupertinoButton.filled(
                    child: const Text("Cost: 1000 CFA"),
                    onPressed: () {
                      debugPrint("nothing doing");
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
