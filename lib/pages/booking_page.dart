import 'package:flutter/material.dart';
import 'package:foodinz/widgets/food_app_bar.dart';
import 'package:foodinz/widgets/food_date_card.dart';
import 'package:foodinz/widgets/reservation_date.dart';
import 'package:provider/provider.dart';

import '../models/food.dart';
import '../providers/meals.dart';

class BookingPage extends StatelessWidget {
  const BookingPage(
      {Key? key, required this.foodId, required this.restaurantId})
      : super(key: key);
  final String restaurantId, foodId;

  @override
  Widget build(BuildContext context) {
    final Food meal = Provider.of<MealsData>(context).getMeal(foodId);

    return LayoutBuilder(builder: (context, constraints) {
      final h = constraints.maxHeight;
      final w = constraints.maxWidth;

      return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: FoodAppBar(title: "Book a place"),
          ),
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                  height: h * .9,
                  width: w,
                  child: Column(
                    children: [
                      SizedBox(
                        height: h * .075,
                        child: ReservationDates(dates: [
                          DateTime.now(),
                          DateTime.now().add(
                            Duration(hours: 54),
                          ),
                          DateTime.now().add(
                            Duration(hours: 84),
                          ),
                          DateTime.now().add(
                            Duration(hours: 174),
                          ),
                          DateTime.now().add(
                            Duration(hours: 274),
                          ),
                          DateTime.now().add(
                            Duration(hours: 314),
                          ),
                          DateTime.now().add(
                            Duration(hours: 454),
                          ),
                          DateTime.now().add(
                            Duration(hours: 674),
                          ),
                          DateTime.now().add(
                            Duration(hours: 774),
                          ),
                          DateTime.now().add(
                            Duration(hours: 874),
                          ),
                        ]),
                      )
                    ],
                  ))
            ],
          ));
    });
  }
}
