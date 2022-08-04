import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String name,
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
  bool momo,
      cash,
      following,
      tableReservation,
      specialOrders,
      homeDelivery,
      verified,
      foodReservation,
      ghostKitchen;
  final double lat, lng;
  final List<String> categories, gallery;
  double deliveryCost;
  int comments = 0;
  int likes = 0;
  int followers;

  Restaurant(
      {required this.address,
      required this.name,
      required this.categories,
      required this.gallery,
      required this.followers,
      required this.verified,
      required this.lng,
      required this.lat,
      this.comments = 0,
      this.likes = 0,
      this.deliveryCost = 500,
      required this.restaurantId,
      required this.businessPhoto,
      required this.tableReservation,
      required this.cash,
      required this.momo,
      required this.specialOrders,
      required this.avatar,
      required this.closingTime,
      this.following = false,
      required this.openingTime,
      required this.companyName,
      required this.username,
      required this.email,
      required this.foodReservation,
      required this.ghostKitchen,
      required this.homeDelivery,
      required this.phoneNumber});
}
