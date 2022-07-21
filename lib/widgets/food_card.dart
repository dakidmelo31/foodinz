import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({Key? key, required this.image, this.restHero})
      : super(key: key);
  final String image;
  final String? restHero;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: Hero(
        tag: restHero!,
        child: CachedNetworkImage(
          imageUrl: image,
          alignment: Alignment.center,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          errorWidget: (_, string, stackTrace) {
            return Lottie.asset("assets/no-connection2.json");
          },
          height: size.height * .35,
        ),
      ),
    );
  }
}
