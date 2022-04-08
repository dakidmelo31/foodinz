import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foodinz/models/message_data.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({Key? key, required this.message}) : super(key: key);
  final MessageData message;
  @override
  Widget build(BuildContext context) {
    return Random().nextBool()
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(.3),
                              spreadRadius: 8,
                              blurRadius: 4,
                              offset: Offset(0, 10))
                        ],
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(10))),
                    padding: EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    child: Text(message.message)),
              ),
              SizedBox(
                width: 40,
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(.3),
                              spreadRadius: 8,
                              blurRadius: 4,
                              offset: Offset(0, 10))
                        ],
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(10))),
                    padding: EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    child: Text(message.message)),
              ),
            ],
          );
  }
}
