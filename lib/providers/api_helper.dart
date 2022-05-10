import 'package:cloud_firestore/cloud_firestore.dart';

class ApiHelper {
  static final ApiHelper instance = ApiHelper._internal();
  static final db = FirebaseFirestore.instance.collection('data');
  factory ApiHelper() {
    return instance;
  }
  ApiHelper._internal() {}
  save(data) async {
    await db.add(data);
  }
}
