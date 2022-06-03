import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class RowData extends StatelessWidget {
  const RowData({Key? key, required this.property, required this.value})
      : super(key: key);
  final String property, value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          property,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        const SizedBox(width: 25),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              overflow: TextOverflow.ellipsis,
              fontSize: 15.7,
            ),
          ),
        ),
      ],
    );
  }
}
