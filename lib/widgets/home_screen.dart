import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/widgets/search_page.dart';
import 'package:foodinz/widgets/street_restaurants.dart';
import 'package:provider/provider.dart';

import '../pages/recommended_screen.dart';
import '../providers/auth.dart';
import '../providers/data.dart';
import '../providers/meals.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _userData = Provider.of<MyData>(context, listen: true);

    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            width: size.width,
            height: size.height,
            child: Showcase(userData: _userData),
          ),
          // if (search)
        ],
      ),
    );
  }
}
