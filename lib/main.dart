import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodinz/firebase_options.dart';
import 'package:foodinz/local_notif.dart';
import 'package:foodinz/pages/home.dart';
import 'package:foodinz/pages/start_page.dart';
import 'package:foodinz/providers/auth.dart';
import 'package:foodinz/providers/bookmarks.dart';
import 'package:foodinz/providers/cart.dart';
import 'package:foodinz/providers/comments_service.dart';
import 'package:foodinz/providers/data.dart';
import 'package:foodinz/themes/light_theme.dart';
import 'package:provider/provider.dart';

import 'models/food.dart';
import 'providers/category_serice.dart';
import 'providers/meals.dart';
import 'package:timezone/timezone.dart' as tz;

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

TextStyle myTexts = TextStyle(color: Color.fromARGB(255, 226, 226, 226));
TextStyle headingStyles = const TextStyle(
    color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService().init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
            Home.routeName: (_) => const Home()
          }),
    );
  }
}
