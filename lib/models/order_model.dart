import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Order {
  final String restaurantId;
  final String status;
  final List<int> quantities;
  final List<String> names;
  final List<double> prices;
  final bool homeDelivery;
  final int deliveryCost;
  final Timestamp time;
  final String userId;
  String orderId = '';
  final int friendlyId;
  Order({
    required this.restaurantId,
    required this.status,
    required this.quantities,
    required this.names,
    required this.prices,
    required this.homeDelivery,
    required this.deliveryCost,
    required this.time,
    required this.friendlyId,
    required this.userId,
  });

  Order copyWith({
    String? restaurantId,
    String? status,
    List<int>? quantities,
    List<String>? names,
    List<double>? prices,
    bool? homeDelivery,
    int? deliveryCost,
    Timestamp? time,
    String? userId,
    int? friendlyId,
  }) {
    return Order(
      restaurantId: restaurantId ?? this.restaurantId,
      status: status ?? this.status,
      friendlyId: friendlyId ?? this.friendlyId,
      quantities: quantities ?? this.quantities,
      names: names ?? this.names,
      prices: prices ?? this.prices,
      homeDelivery: homeDelivery ?? this.homeDelivery,
      deliveryCost: deliveryCost ?? this.deliveryCost,
      time: time ?? this.time,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'restaurantId': restaurantId});
    result.addAll({'friendlyId': friendlyId});
    result.addAll({'status': status});
    result.addAll({'quantities': quantities});
    result.addAll({'names': names});
    result.addAll({'prices': prices});
    result.addAll({'homeDelivery': homeDelivery});
    result.addAll({'deliveryCost': deliveryCost});
    result.addAll({'time': FieldValue.serverTimestamp()});
    result.addAll({'userId': userId});

    return result;
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      restaurantId: map['restaurantId'] ?? '',
      status: map['status'] ?? '',
      friendlyId: map['friendlyId'] ?? Random().nextInt(75044),
      quantities: List<int>.from(map['quantities']),
      names: List<String>.from(map['names']),
      prices: List<double>.from(map['prices']),
      homeDelivery: map['homeDelivery'] ?? false,
      deliveryCost: map['deliveryCost']?.toInt() ?? 0,
      time: map['time'],
      userId: map['userId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Order(restaurantId: $restaurantId, status: $status, quantities: $quantities, names: $names, prices: $prices, homeDelivery: $homeDelivery, deliveryCost: $deliveryCost, time: $time, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Order &&
        other.restaurantId == restaurantId &&
        other.status == status &&
        listEquals(other.quantities, quantities) &&
        listEquals(other.names, names) &&
        listEquals(other.prices, prices) &&
        other.homeDelivery == homeDelivery &&
        other.deliveryCost == deliveryCost &&
        other.time == time &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return restaurantId.hashCode ^
        status.hashCode ^
        quantities.hashCode ^
        names.hashCode ^
        prices.hashCode ^
        homeDelivery.hashCode ^
        deliveryCost.hashCode ^
        time.hashCode ^
        userId.hashCode;
  }
}
