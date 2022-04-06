import 'package:flutter/material.dart';

class RestaurantInfoTableItem extends StatelessWidget {
  const RestaurantInfoTableItem(
      {Key? key,
      required this.icon,
      required this.description,
      required this.title})
      : super(key: key);
  final String title, description;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        border: title != "Type"
            ? null
            : Border.symmetric(
                vertical:
                    BorderSide(color: Colors.grey.withOpacity(.3), width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              title,
              style: const TextStyle(
                color: Color.fromARGB(255, 156, 156, 156),
              ),
            ),
          ),
          Row(
            children: [
              icon,
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
