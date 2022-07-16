import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Duration transitionDuration = Duration(milliseconds: 400);
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

enum OrderStatus { pending, processing, ready, complete }

final List<String> globalCategories = [
  "Breakfast",
  "Lunch",
  "Dinner",
  "Road side",
  "Beef",
  "Dessert",
  "Groceries",
  "Specials",
  "Simple",
  "Traditional",
  "Home Delivery",
  "Vegetarian",
  "Casual",
  "Classic"
];

Future<bool> checkLike({required String foodId}) async {
  final prefs = await SharedPreferences.getInstance();
  bool answer = prefs.containsKey(foodId);
  return answer;
}

Future<void> toggleFoodLike({required String foodId}) async {
  final prefs = await SharedPreferences.getInstance();
  if (await checkLike(foodId: foodId)) {
    debugPrint("removing like");
    prefs.remove(foodId);
  } else {
    prefs.setBool(foodId, true);
    debugPrint("adding like");
  }
}

addToLikes({required String foodId}) async {
  await firestore
      .collection("allLikes")
      .doc(auth.currentUser!.uid)
      .collection("myLikes")
      .add({"foodId": foodId})
      .then((value) => debugPrint("Done adding like: $value"))
      .catchError((onError) {
        debugPrint("Error found adding user: $onError");
      });
}

removeFromLikes({required String foodId}) async {
  await firestore
      .collection("allLikes")
      .doc(auth.currentUser!.uid)
      .collection("myLikes")
      .get()
      .then((value) {
    var data = value.docs;

    for (var item in data) {
      if (item['foodId'] == foodId) {
        firestore
            .collection("allLikes")
            .doc(auth.currentUser!.uid)
            .collection("myLikes")
            .doc(item.id)
            .delete()
            .then((value) {
          debugPrint("done deleting");
        });
      }
    }
  });
}

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

Widget errorWidget2 = Lottie.asset("assets/no-connection2.json");
Widget errorWidget1 = Lottie.asset("assets/no-connection.json");
Widget loadingWidget = Lottie.asset("assets/loading5.json");

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

updateAllData(
    {required String collection,
    required String doc,
    required dynamic data,
    required String field}) async {
  // await FirebaseFirestore.instance.collection("reviews").doc(doc).delete();
  FirebaseFirestore.instance
      .collection(collection)
      .doc(doc)
      .set({field: data}, SetOptions(merge: true)).then(
    (value) => debugPrint("update info"),
  );
}

Color getColor({required String status}) {
  return status == "pending"
      ? Colors.grey
      : status == "processing"
          ? Colors.blue
          : status.toLowerCase() == "takeout"
              ? Colors.lightGreen
              : status.toLowerCase() == "completed"
                  ? Colors.deepPurple
                  : Colors.pink;
}
