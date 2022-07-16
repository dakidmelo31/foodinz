import 'package:carousel_grid/carousel_grid.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/models/restaurants.dart';
import 'package:intl/intl.dart';

import '../pages/maps/single_map.dart';
import '../themes/light_theme.dart';
import 'transitions.dart';

class OtherDetails extends StatelessWidget {
  const OtherDetails({Key? key, required this.restaurant}) : super(key: key);
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
          elevation: 10.0,
          shadowColor: Colors.black.withOpacity(.3),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text("We Open At"),
                    Text(restaurant.openingTime),
                  ],
                ),
                Column(
                  children: [
                    const Text("We Close At"),
                    Text(restaurant.closingTime),
                  ],
                ),
              ],
            ),
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              VerticalSizeTransition(
                child: RestaurantMap(
                  lat: restaurant.lat,
                  long: restaurant.long,
                ),
              ),
            );
          },
          leading: Icon(
            Icons.map_rounded,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(restaurant.address),
          subtitle: const Text("Tap to open your map"),
        ),
        ListTile(
          leading: Icon(
            Icons.phone_missed_rounded,
            color: Theme.of(context).primaryColor,
          ),
          title: SelectableText(restaurant.phoneNumber),
        ),
        ListTile(
          leading: Icon(
            Icons.mail_rounded,
            color: Theme.of(context).primaryColor,
          ),
          title: SelectableText(restaurant.email),
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
            child: Text(
              "Our Details",
              style: Primary.bigHeading,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(
            Icons.delivery_dining_rounded,
            color: Colors.pink,
          ),
          title: const SelectableText("Home Delivery"),
          trailing: Icon(
            restaurant.homeDelivery ? Icons.check_rounded : Icons.close_rounded,
            color: restaurant.homeDelivery ? Colors.green : Colors.pink,
          ),
        ),
        ListTile(
          leading: const Icon(
            Icons.menu_book_rounded,
            color: Colors.pink,
          ),
          title: const SelectableText("Taking of Special Commands"),
          trailing: Icon(
            restaurant.specialOrders
                ? Icons.check_rounded
                : Icons.close_rounded,
            color: restaurant.specialOrders ? Colors.green : Colors.pink,
          ),
        ),
        ListTile(
          leading: const Icon(
            Icons.delivery_dining_rounded,
            color: Colors.pink,
          ),
          title: const SelectableText("Table Reservations"),
          trailing: Icon(
            restaurant.tableReservation
                ? Icons.check_rounded
                : Icons.close_rounded,
            color: restaurant.tableReservation ? Colors.green : Colors.pink,
          ),
        ),
        ListTile(
          leading: const Icon(
            Icons.delivery_dining_rounded,
            color: Colors.pink,
          ),
          title: const SelectableText("Food Reservations"),
          trailing: Icon(
            restaurant.foodReservation
                ? Icons.check_rounded
                : Icons.close_rounded,
            color: restaurant.foodReservation ? Colors.green : Colors.pink,
          ),
        ),
        ListTile(
          leading: const Icon(
            Icons.delivery_dining_rounded,
            color: Colors.pink,
          ),
          title: const SelectableText("Mobile Money Payments"),
          trailing: Icon(
            restaurant.momo ? Icons.check_rounded : Icons.close_rounded,
            color: restaurant.momo ? Colors.green : Colors.pink,
          ),
        ),
        ListTile(
          leading: const Icon(
            Icons.home_mini_rounded,
            color: Colors.pink,
          ),
          title: const SelectableText("Selling from Home"),
          trailing: Icon(
            restaurant.ghostKitchen ? Icons.check_rounded : Icons.close_rounded,
            color: restaurant.ghostKitchen ? Colors.green : Colors.pink,
          ),
        ),
        if (restaurant.homeDelivery)
          ListTile(
            leading: const Icon(
              Icons.delivery_dining_rounded,
              color: Colors.pink,
            ),
            title: const SelectableText("Food Reservations"),
            trailing:
                Text(NumberFormat().format(restaurant.deliveryCost) + " CFA"),
          ),
        CarouselGrid(
          height: 285,
          width: 400,
          listUrlImages: restaurant.gallery,
          iconBack: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
