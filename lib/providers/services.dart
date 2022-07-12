import 'package:flutter/cupertino.dart';

import '../global.dart';
import '../models/service.dart';

class ServicesData with ChangeNotifier {
  List<ServiceModel> services = [];

  ServicesData() {
    loadServices();
  }
  Future<void> loadServices() async {
    firestore
        .collection("services")
        .orderBy("created_time", descending: true)
        .snapshots()
        .listen((event) {
      services.clear();
      for (var serviceData in event.docs) {
        String documentID = serviceData.id;

        ServiceModel service = ServiceModel(
          serviceId: documentID,
          likes: serviceData['likes'] as int,
          description: serviceData['description'],
          comments: serviceData['comments'] as int,
          name: serviceData["name"],
          negociable: serviceData["negociable"],
          image: serviceData['image'],
          cost: serviceData['cost'], //double.parse(data['price'])
          restaurantId: serviceData['restaurantId'],
          gallery: List<String>.from(serviceData['gallery']),
          duration: serviceData['duration'],
          coverage: serviceData['coverage'],
        );
        services.add(service);
      }
    });
    notifyListeners();
  }
}
