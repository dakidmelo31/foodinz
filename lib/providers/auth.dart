import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:foodinz/global.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

FirebaseAuth auth = FirebaseAuth.instance;

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class UserData with ChangeNotifier {
  UserModel? user;
  String? name;
  String? photoURL;
  String? userId;
  String? deviceToken;
  UserData() {
    loadUser();
    isLocationSet();
  }

  loadUser() async {
    var userTokenId = await getToken();
    if (userTokenId == null) {
      debugPrint("no token found");
    } else {
      debugPrint("user token is this: $userTokenId");
    }

    _firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .get()
        .then((value) {
      user = UserModel.fromMap(value.data()!);
      this.name = user!.name;
      this.photoURL = user!.image;
      this.userId = user!.userId;
      this.deviceToken = userTokenId;
      debugPrint(user!.name);
      debugPrint("user is done loading");
      notifyListeners();
    });
  }

  isLocationSet() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("locationSet")) {
      debugPrint("user's location is updated");
    }
  }
}
