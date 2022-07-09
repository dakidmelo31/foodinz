import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../global.dart';
import '../models/review_models.dart';

class ReviewProvider with ChangeNotifier {
  final _reviewSnapshot = <DocumentSnapshot>[];
  String _errorMessage = "";
  bool _hasNext = true;
  int documentLimit = 15;
  bool _isFetchingReviews = false;

  String get errorMessage => _errorMessage;
  bool get hasNext => _hasNext;
  bool get isFetchingReviews => _isFetchingReviews;
  List<ReviewModel> get reviews => _reviewSnapshot.map((e) {
        final review = e.data() as Map<String, dynamic>;
        var current = ReviewModel.fromMap(review);
        current.reviewId = e.id;
        return current;
      }).toList();

  var _startAfter = null;

  Future fetchNextReviews({required String foodId}) async {
    _errorMessage = '';
    if (isFetchingReviews) {
      return;
    }
    _isFetchingReviews = true;

    try {
      late final snap;
      _startAfter = _reviewSnapshot.isEmpty ? null : _reviewSnapshot.last;
      if (_startAfter == null) {
        _reviewSnapshot.clear();
        if (auth.currentUser == null) {
          snap = await FirebaseFirestore.instance
              .collection("reviews")
              .where("foodId", isEqualTo: foodId)
              .orderBy("created_at")
              .limit(documentLimit)
              .get();
        } else {
          snap = await FirebaseFirestore.instance
              .collection("reviews")
              .where("userId", isEqualTo: auth.currentUser!.uid)
              .where("foodId", isEqualTo: foodId)
              .orderBy("created_at")
              .limit(documentLimit)
              .get();
        }
        debugPrint("done loading reviews without users");
      } else {
        _reviewSnapshot.clear();

        if (auth.currentUser == null) {
          snap = await FirebaseFirestore.instance
              .collection("reviews")
              .where("foodId", isEqualTo: foodId)
              .orderBy("created_at")
              .startAfterDocument(_startAfter)
              .limit(documentLimit)
              .get();
        } else {
          snap = await FirebaseFirestore.instance
              .collection("reviews")
              .where("foodId", isEqualTo: foodId)
              .orderBy("created_at")
              .startAfterDocument(_startAfter)
              .limit(documentLimit)
              .get();
        }
        debugPrint("done loading reviews with users");
      }
      debugPrint("loading reviews");
      _reviewSnapshot.addAll(snap.docs);

      if (snap.docs.length < documentLimit) _hasNext = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }
    _isFetchingReviews = false;
  }
}
