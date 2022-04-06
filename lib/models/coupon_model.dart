import 'package:cloud_firestore/cloud_firestore.dart';

class Coupon {
  final String couponCode, couponId, restaurantId, description, discountType;

  List<String> products;
  final double value;

  Coupon({
    required this.couponId,
    required this.couponCode,
    required this.restaurantId,
    required this.description,
    required this.discountType,
    required this.products,
    required this.value,
  });
}
