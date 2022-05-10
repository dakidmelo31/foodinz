import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodinz/models/cloud_notification.dart';
import 'package:foodinz/providers/api_helper.dart';
import 'package:provider/provider.dart';
import 'package:foodinz/firebase_options.dart';
import 'package:foodinz/pages/home.dart';
import 'package:foodinz/pages/start_page.dart';
import 'package:foodinz/providers/auth.dart';
import 'package:foodinz/providers/bookmarks.dart';
import 'package:foodinz/providers/cart.dart';
import 'package:foodinz/providers/comments_service.dart';
import 'package:foodinz/providers/data.dart';
import 'package:foodinz/providers/notification_stream.dart';
import 'package:foodinz/themes/light_theme.dart';
import 'package:workmanager/workmanager.dart';
import 'global.dart';
import 'providers/category_serice.dart';
import 'providers/meals.dart';

import 'providers/message_database.dart';
import 'providers/notification_services.dart';

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

TextStyle myTexts = const TextStyle(color: Color.fromARGB(255, 226, 226, 226));
TextStyle headingStyles = const TextStyle(
    color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700);

void callbackDispatcher() {
  Workmanager().executeTask(((taskName, inputData) async {
    //show local notif
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    ApiHelper().save(inputData);
    await NotificationService().init();
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseFirestore.instance
          .collection("notifications")
          .where("recipient", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then(((QuerySnapshot value) {
        for (var data in value.docs) {
          final String notificationId = data.id;
          CloudNotification notification =
              CloudNotification.fromMap(data.data() as Map<String, dynamic>);
          sendNotif(
                  description: notification.description,
                  title: notification.title,
                  payload: notification.payload)
              .then((value) =>
                  deleteCloudNotification(notificationId: notificationId));
//delete the notification
        }
      }));
    }

    debugPrint("show notification in background");
    Workmanager().registerPeriodicTask("foodin_city", "foodin_city_app",
        frequency: Duration(minutes: 15),
        initialDelay: Duration(minutes: 1),
        inputData: {"data1": "value1", "data2": "value2"});

    return Future.value(true);
  }));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

// needed if you intend to initialize in the `main` function
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask(
    "foodin_city",
    "foodin_notifications",
    initialDelay: Duration(minutes: 1),
    frequency: Duration(minutes: 15),
    inputData: {"data1": "value1", "data2": "value2"},
  );

  await NotificationService().init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DatabaseHelper.instance),
        ChangeNotifierProvider(create: (_) => RestaurantData()),
        ChangeNotifierProvider(create: (_) => MealsData()),
        ChangeNotifierProvider(create: (_) => CategoryData()),
        ChangeNotifierProvider(create: (_) => CartData()),
        ChangeNotifierProvider(create: (_) => CommentsData()),
        ChangeNotifierProvider(create: (_) => BookmarkData()),
        ChangeNotifierProvider(
          create: (_) => UserData(),
        ),
      ],
      child: MaterialApp(
          // showPerformanceOverlay: true,
          debugShowCheckedModeBanner: false,
          theme: Primary.primaryTheme,
          routes: {
            StartPage.routeName: (_) => const StartPage(),
            Home.routeName: (_) => const NotificationStream(child: const Home())
          }),
    );
  }
}
