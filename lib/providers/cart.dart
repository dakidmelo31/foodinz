import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/cart.dart';
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

    final order = Order(
      homeDelivery: isHomeDelivery,
      names: names,
      quantities: quantities,
      deliveryCost: deliveryCost,
      prices: prices,
      restaurantId: myCart[0].restaurantId,
      time: DateTime.now(),
      userId: auth.currentUser!.uid,
      status: 'pending',
    );
    firestore.collection("orders").doc().set(order.toMap()).then((value) {
      debugPrint("Done placing order");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Checkout Successful.", style: Primary.whiteText),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context, true);
      myCart.clear();
    }).catchError((onError) {
      debugPrint(onError.toString());
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
    updateTotal();
    notifyListeners();
  }
}
