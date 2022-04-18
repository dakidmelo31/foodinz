import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatelessWidget {
  final int orderId;
  OrderDetails({required this.orderId});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * .65,
      width: double.infinity,
      color: Colors.blue,
    );
  }
}
