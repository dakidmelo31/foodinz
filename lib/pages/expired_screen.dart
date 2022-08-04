import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../themes/light_theme.dart';

class ExpiredScreen extends StatefulWidget {
  const ExpiredScreen({Key? key}) : super(key: key);

  @override
  State<ExpiredScreen> createState() => _ExpiredScreenState();
}

class _ExpiredScreenState extends State<ExpiredScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Column(
          children: [
            Spacer(),
            Lottie.asset(
              "assets/maintenance3.json",
              width: size.width - 100,
              height: size.width - 100,
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
            Spacer(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Thank You for Your time",
                  style: Primary.bigHeading,
                ),
              ),
            ),
            Center(
                child: Text(
                    "You can now tell us how your experience was with the app.")),
            Spacer(),
            CupertinoButton.filled(
                child: Text("Tell Us on Whatsapp"),
                onPressed: () {
                  final link = WhatsAppUnilink(
                      phoneNumber: "+237650981130",
                      text: "Hi, I would like to say a few things:");
                  launch("$link");
                }),
            SizedBox(height: 15.0),
            CupertinoButton.filled(
              child: Text("Tell Us on Whatsapp"),
              onPressed: () {
                final link = WhatsAppUnilink(
                    phoneNumber: "+237672108476",
                    text: "Hi, I would like to say a few things:");
                launch("$link");
              },
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
