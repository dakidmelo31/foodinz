import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const Duration transitionDuration = Duration(milliseconds: 400);
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

enum OrderStatus { pending, processing, ready, complete }

Future<void> sendNotif(
    {required String title,
    required String description,
    String? payload}) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    "channelId",
    "Foodin City",
    channelDescription: "Welcome to foodin",
    importance: Importance.high,
  );
  const IOSNotificationDetails iosNotificationDetails =
      IOSNotificationDetails(subtitle: "foodin city");
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
      iOS: iosNotificationDetails, android: androidNotificationDetails);
  await FlutterLocalNotificationsPlugin().show(
      Random().nextInt(500), title, description, platformChannelSpecifics,
      payload: payload);
}

deleteCloudNotification({required String notificationId}) {
  firestore
      .collection("notifications")
      .doc(notificationId)
      .delete()
      .then((value) {
    debugPrint("deleted notification");
  }).catchError((onError) {
    debugPrint("error while deleting notification");
  });
}

Future<String?> getToken() async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  return fcmToken;
}

getCount({required String collection, required String field}) async {
  int count = await FirebaseFirestore.instance
      .collection(collection)
      .where("foodId", isEqualTo: field)
      .get()
      .then((querySnapshot) {
    return querySnapshot.docs.length;
  });

  return count;
}

updateData(
    {required String collection,
    required String doc,
    required dynamic data,
    required String field}) async {
  await FirebaseFirestore.instance.collection("reviews").doc(doc).delete();
  // FirebaseFirestore.instance
  //     .collection(collection)
  //     .doc(doc)
  //     .set({field: data}, SetOptions(merge: true)).then(
  //   (value) => debugPrint("update info"),
  // );
}
