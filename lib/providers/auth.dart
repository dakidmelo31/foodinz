import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:foodinz/global.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

FirebaseAuth auth = FirebaseAuth.instance;

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class MyData with ChangeNotifier {
  UserModel user = UserModel(
      name: "name",
      image: "image",
      userId: 'userId',
      phone: 'phone',
      lat: 0,
      long: 0);
  MyData() {
    loadUser();
    isLocationSet();
  }

  bool loadingUser = true;
  loadUser() async {
    loadingUser = true;
    var userTokenId = await getToken();
    debugPrint("show me this");
    if (userTokenId == null) {
      debugPrint("no token found");
    } else {
      debugPrint("user token is this: $userTokenId");
    }

    if (user.name == "name") {
      await _firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) {
        user = UserModel.fromMap(value.data()!);
        debugPrint("User Image URL IS: " + user.image.toString());
        user.userId = value.id;
      });
    } else {
      debugPrint("user already exists");
    }
    loadingUser = false;
    notifyListeners();
  }

  isLocationSet() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("locationSet")) {
      debugPrint("user's location is updated");
    }
  }
}
