import 'package:flutter/cupertino.dart';

import '../global.dart';
import '../models/service.dart';
import 'global_data.dart';

class ServicesData with ChangeNotifier {
  List<ServiceModel> services = [];

  ServicesData() {
    loadServices();
  }
  bool loadingServices = false;
  Future<void> loadServices() async {
    loadingServices = true;

    firestore
        .collection("services")
        .orderBy("created_time", descending: true)
        .snapshots()
        .listen((event) {
      services.clear();
      loadingServices = true;
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

  void toggleFavorite(String id) async {
    ServiceModel meal = services.firstWhere(
        (element) => element.serviceId == id,
        orElse: () => ServiceModel(
            cost: "",
            coverage: "",
            serviceId: "",
            duration: "",
            description: "",
            image: "",
            name: "",
            restaurantId: "",
            gallery: [],
            likes: 0,
            comments: 0,
            negociable: false));
    final dbManager = await DBManager.instance;
    if (meal.serviceId.isEmpty) {
      return;
    }
    dbManager.addFavoriteService(foodId: id);
    services.firstWhere((element) => element.serviceId == id).favorite =
        !meal.favorite;

    notifyListeners();
  }

  void toggleMeal({required String id}) {
    ServiceModel meal =
        services.firstWhere((element) => element.serviceId == id);
    final dbManager = DBManager.instance;

    dbManager.addFavoriteService(foodId: id);
    if (meal.favorite) {
      //reduce likes
      services.firstWhere((element) => element.serviceId == id).likes =
          meal.likes - 1;
    } else {
      //add like
      services.firstWhere((element) => element.serviceId == id).likes =
          meal.likes + 1;
    }
    services.firstWhere((element) => element.serviceId == id).favorite =
        !meal.favorite;
    notifyListeners();
  }
}
