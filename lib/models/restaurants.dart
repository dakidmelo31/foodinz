import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String name,
      category,
      address,
      restaurantId,
      closingTime,
      openingTime,
      businessPhoto,
      avatar,
      email,
      phoneNumber,
      username,
      companyName;
  final bool momo,
      cash,
      tableReservation,
      specialOrders,
      homeDelivery,
      foodReservation,
      ghostKitchen;
  final double lat, long;

  Restaurant(
      {required this.address,
      required this.name,
      required this.category,
      required this.long,
      required this.lat,
      required this.restaurantId,
      required this.businessPhoto,
      required this.tableReservation,
      required this.cash,
      required this.momo,
      required this.specialOrders,
      required this.avatar,
      required this.closingTime,
      required this.openingTime,
      required this.companyName,
      required this.username,
      required this.email,
      required this.foodReservation,
      required this.ghostKitchen,
      required this.homeDelivery,
      required this.phoneNumber});
}
