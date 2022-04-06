import 'package:flutter/widgets.dart';

import '../models/cart.dart';

class CartData with ChangeNotifier {
  List<Cart> myCart = [];

  void addToCart(Cart item) {
    myCart.add(item);
    updateTotal();
    notifyListeners();
  }

  double total = 0;
  void updateTotal() {
    myCart.forEach((element) {
      total += element.price * element.quantity;
    });
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

  void removeFromCart(String id) {
    myCart.removeWhere((element) => element.foodId == id);
    updateTotal();
    notifyListeners();
  }
}
