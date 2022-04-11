import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/models/restaurants.dart';
import 'package:foodinz/pages/map_page.dart';
import 'package:foodinz/widgets/food_info_table_item.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/food.dart';
import 'restaurant_info_table_item.dart';

class RestaurantInfoTable extends StatelessWidget {
  const RestaurantInfoTable({Key? key, required this.restaurant})
      : super(key: key);
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    final myNumber = restaurant.phoneNumber.split("");
    String num = "";
    int count = 0;

    for (String n in myNumber) {
      if (count % 3 == 0 && count != 0) {
        num = num + " - " + n;
      } else {
        num = num + n;
      }
      count++;
    }
    _launchURL() async {
      await launch(
        restaurant.phoneNumber,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Flexible(
          flex: 1,
          child: RestaurantInfoTableItem(
              icon: Icon(Icons.star_rounded, color: Colors.amber, size: 16),
              description: "32k",
              title: "Ratings"),
        ),
        FittedBox(
          child: RestaurantInfoTableItem(
              icon: const Icon(Icons.restaurant, color: Colors.blue, size: 16),
              description:
                  restaurant.ghostKitchen ? "Restaurant" : "Direct Sales",
              title: "Type"),
        ),
        OpenContainer(
            transitionDuration: const Duration(milliseconds: 700),
            transitionType: ContainerTransitionType.fadeThrough,
            middleColor: Colors.deepPurple,
            openBuilder: (_, closedContainer) =>
                MapDetailsScreen(restaurant: restaurant),
            closedBuilder: (_, openContainer) => InkWell(
                  onTap: openContainer,
                  child: const FittedBox(
                    child: RestaurantInfoTableItem(
                        icon: Icon(Icons.location_on_rounded,
                            color: Colors.pink, size: 16),
                        description: "3.5 km",
                        title: "Distance"),
                  ),
                )),
      ],
    );
  }
}
