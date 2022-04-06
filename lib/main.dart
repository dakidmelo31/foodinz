import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodinz/firebase_options.dart';
import 'package:foodinz/pages/home.dart';
import 'package:foodinz/pages/start_page.dart';
import 'package:foodinz/providers/auth.dart';
import 'package:foodinz/providers/bookmarks.dart';
import 'package:foodinz/providers/cart.dart';
import 'package:foodinz/providers/comments_service.dart';
import 'package:foodinz/providers/data.dart';
import 'package:provider/provider.dart';

import 'models/food.dart';
import 'providers/category_serice.dart';
import 'providers/meals.dart';

TextStyle myTexts = TextStyle(color: Color.fromARGB(255, 226, 226, 226));
TextStyle headingStyles = const TextStyle(
    color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

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
        ChangeNotifierProvider(create: (_) => RestaurantData()),
        ChangeNotifierProvider(create: (_) => MealsData()),
        ChangeNotifierProvider(create: (_) => CategoryData()),
        ChangeNotifierProvider(create: (_) => CartData()),
        ChangeNotifierProvider(create: (_) => CommentsData()),
        ChangeNotifierProvider(create: (_) => BookmarkData()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          routes: {
            StartPage.routeName: (_) => const StartPage(),
            Home.routeName: (_) => const Home()
          }),
    );
  }
}
