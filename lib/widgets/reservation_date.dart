import 'package:flutter/material.dart';
import 'package:foodinz/widgets/food_date_card.dart';

class ReservationDates extends StatefulWidget {
  const ReservationDates({Key? key, required this.dates}) : super(key: key);
  final List<DateTime> dates;

  @override
  State<ReservationDates> createState() => _ReservationDatesState();
}

class _ReservationDatesState extends State<ReservationDates> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        clipBehavior: Clip.none,
        itemBuilder: (_, index) {
          return GestureDetector(
              child: FoodDateCard(
                  date: widget.dates[index],
                  isSelected: _selectedIndex == index));
        },
        separatorBuilder: (_, __) => SizedBox(
              width: 10,
            ),
        itemCount: widget.dates.length);
  }
}
