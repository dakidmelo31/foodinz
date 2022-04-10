import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:timeago/timeago.dart' as timeAgo;

import 'order_details.dart';

class OrderDialog extends StatelessWidget {
  const OrderDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return OpenContainer(
      openBuilder: (_, __) => OrderDetails(orderId: "sAd32DDe4x52Y2"),
      closedBuilder: (_, openContainer) => Card(
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        elevation: 15,
        child: InkWell(
          onTap: openContainer,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  timeAgo.format(
                    DateTime.now().subtract(
                      Duration(
                        hours: 5033,
                      ),
                    ),
                  ),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
