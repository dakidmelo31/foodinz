import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/recommended_screen.dart';
import '../providers/auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key, required this.data}) : super(key: key);
  final MyData data;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            width: size.width,
            height: size.height,
            child: Showcase(userData: data),
          ),
          // if (search)
        ],
      ),
    );
  }
}
