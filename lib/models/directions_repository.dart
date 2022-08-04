import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../.env.dart';
import 'directions.dart';

class DirectionsRepository {
  static const String _baseUrl =
      "https://maps.google.com/maps/api/directions/json?";
  late final Dio _dio;

  DirectionsRepository({required Dio dio}) : _dio = dio;

  Future<Directions> getDirections(
      {required LatLng source, required LatLng destination}) async {
    final response = await _dio.get(_baseUrl, queryParameters: {
      "origin": '${source.latitude}, ${source.longitude}',
      "destination": '${destination.latitude}, ${destination.longitude}',
      'key': googleApiKey,
    });

    if (response.statusCode == 200) {
      debugPrint("data returned");
    }
    return Directions.fromMap(response.data);
  }
}
