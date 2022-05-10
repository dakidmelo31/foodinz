import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:foodinz/global.dart';
import 'package:foodinz/local_notif.dart';
import 'package:foodinz/models/cloud_notification.dart';
import 'package:foodinz/providers/data.dart';
import 'package:foodinz/providers/message_database.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../models/chats_model.dart';
import '../models/order_model.dart';
import '../themes/light_theme.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

class CartData with ChangeNotifier {
  bool isMultipleRestaurants = false;
  List<Cart> myCart = [];

  void addToCart(Cart item) {
    for (Cart test in myCart) {
      if (test.restaurantId != item.restaurantId) {
        isMultipleRestaurants = true;
      }
    }
    myCart.add(item);
    updateTotal();
    notifyListeners();
  }

  void checkout(
      {required int deliveryCost,
      required bool isHomeDelivery,
      required BuildContext context}) {
    List<String> names = myCart.map((e) {
      return e.name;
    }).toList();
    List<double> prices = myCart.map((e) {
      return e.price;
    }).toList();
    List<int> quantities = myCart.map((e) {
      return e.quantity;
    }).toList();
    int friendlyId = Random().nextInt(99999);
    debugPrint("friendly Id Number: $friendlyId");

    final order = Order(
      homeDelivery: isHomeDelivery,
      friendlyId: friendlyId,
      names: names,
      quantities: quantities,
      deliveryCost: deliveryCost,
      prices: prices,
      restaurantId: myCart[0].restaurantId,
      time: Timestamp.now(),
      userId: auth.currentUser!.uid,
      status: 'pending',
    );
    firestore.collection("orders").doc().set(order.toMap()).then((value) async {
      CloudNotification cloudNotification = CloudNotification(
        title: "New Order for you ",
        description: "Wrap things up with your customer right away.",
        userId: auth.currentUser!.uid,
        payload: order.restaurantId,
        restaurantId: order.restaurantId,
      );
      firestore.collection("notifications").add(cloudNotification.toMap());
      debugPrint("Done placing order");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Checkout Successful.", style: Primary.whiteText),
          backgroundColor: Colors.green,
        ),
      );

      final restaurant = Provider.of<RestaurantData>(context, listen: false)
          .getRestaurant(order.restaurantId);
      final restaurantName = restaurant.companyName;

      sendNotif(
          title: "Order Placed",
          description:
              "You ordered ${order.names.length} items  from $restaurantName just Now. Contact them for payment and scheduling.",
          payload: restaurant.restaurantId);

      myCart.clear();
      total = 0.0;
      Navigator.pop(context, true);
    }).catchError((onError) {
      debugPrint(onError.toString());
    });
  }

  updateField({required String field, required dynamic value}) async {
    firestore
        .collection("orders")
        .where("userId", isEqualTo: auth.currentUser!.uid)
        .get()
        .then((value) {
      for (var i = 0; i < value.docs.length; i++) {
        firestore
            .collection("orders")
            .doc(value.docs[i].id)
            .set({"friendlyId": Random().nextInt(99999)});
        debugPrint("done updating ${value.docs[i].id}");
      }
    });
  }

  void updateCart({required Cart item}) {
    myCart.removeWhere((element) => element.foodId == item.foodId);
    myCart.add(item);
    updateTotal();
    notifyListeners();
  }

  double total = 0;
  void updateTotal() {
    total = 0;
    for (var element in myCart) {
      total = total + (element.price * element.quantity);
    }
    notifyListeners();
  }

  Cart? isAvailable(String id) {
    if (myCart.isEmpty) return null;
    for (Cart item in myCart) {
      if (item.foodId == id) {
        return item;
      }
    }
    return null;
  }

  bool isAlreadyInCart({required String foodId}) {
    bool answer = false;
    for (Cart item in myCart) {
      if (item.foodId == foodId) {
        answer = true;
        break;
      }
    }
    return answer;
  }

  void removeFromCart(String id) {
    myCart.removeWhere((element) => element.foodId == id);

    for (Cart item in myCart) {
      for (Cart test in myCart) {
        if (test.restaurantId != item.restaurantId) {
          debugPrint("multiple restaurants");
          isMultipleRestaurants = true;
          break;
        } else {
          debugPrint("is not multi restaurants");
          isMultipleRestaurants = false;
        }
        if (isMultipleRestaurants) {
          break;
        }
      }
    }
    updateTotal();
    notifyListeners();
  }
}
