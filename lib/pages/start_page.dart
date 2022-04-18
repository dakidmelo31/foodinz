import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/providers/category_serice.dart';
import 'package:foodinz/providers/data.dart';
import 'package:foodinz/providers/meals.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'home.dart';
import 'login.dart';

class StartPage extends StatefulWidget {
  static const routeName = "/";
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

FirebaseAuth auth = FirebaseAuth.instance;

class _StartPageState extends State<StartPage> {
  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("userLoggedIn")) {
      Navigator.pushReplacementNamed(context, Home.routeName);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // checkUser();
    if (auth.currentUser != null) {
      // Navigator.pushReplacementNamed(context, Home.routeName);
    }
    super.initState();
  }

  Future _getPosition() async {
    bool isServiceEnabled;
    // final permission = Geolocator.
  }

  @override
  Widget build(BuildContext context) {
    final restaurantData = Provider.of<RestaurantData>(context, listen: true);
    final mealsData = Provider.of<MealsData>(context, listen: true);
    final categryData = Provider.of<CategoryData>(context, listen: true);
    debugPrint("${restaurantData.restaurants.length}");
    debugPrint("${restaurantData.restaurants.length}");
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      height: double.infinity,
      width: size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/bg1.jpg"),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          repeat: ImageRepeat.noRepeat,
          colorFilter: ColorFilter.linearToSrgbGamma(),
        ),
      ),
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Color.fromRGBO(0, 0, 0, 0.3),
                Color.fromRGBO(0, 0, 0, 0.7),
                Colors.black,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Spacer(),
              SizedBox(
                height: size.height * .3,
                width: size.width * .9,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome To Food!n City",
                      style: headingStyles,
                    ),
                    const Spacer(),
                    Text(
                        "Hungry, Craving, or just wanna explore? Just hop into the food media in your city and find your favourite dishes. and more",
                        style: myTexts),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * .38,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    OpenContainer(
                      transitionDuration: const Duration(milliseconds: 850),
                      middleColor: Colors.black,
                      tappable: true,
                      transitionType: ContainerTransitionType.fade,
                      openElevation: 10,
                      closedColor: Colors.transparent,
                      openBuilder: (_, openContainer) => const Login(),
                      closedBuilder: (_, closedContainer) => Card(
                        color: Colors.orange,
                        elevation: 0,
                        child: InkWell(
                          onTap: closedContainer,
                          child: SizedBox(
                            width: size.width - 170,
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text("Log In"),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(CupertinoIcons.lock)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text("OR", style: myTexts),
                    CupertinoButton(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text("Start Now"),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(CupertinoIcons.person_add)
                          ],
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, Home.routeName);
                          debugPrint("signup new account pressed");
                        }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
