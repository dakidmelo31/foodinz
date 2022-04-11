import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/restaurants.dart';

class MapDetailsScreen extends StatefulWidget {
  const MapDetailsScreen({Key? key, required this.restaurant})
      : super(key: key);
  final Restaurant restaurant;

  @override
  State<MapDetailsScreen> createState() => _MapDetailsScreenState();
}

class _MapDetailsScreenState extends State<MapDetailsScreen> {
  late GoogleMapController googleMapController;
  @override
  void initState() {}

  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  static const initialCameraPosition = CameraPosition(
      target: LatLng(4.154061445217121, 9.25847688945168), zoom: 16.5);

  static final Polyline initialPolyline = Polyline(
      polylineId: PolylineId("value"),
      points: [LatLng(5.0, 10.0), LatLng(7.0, 16.0)]);
  @override
  Widget build(BuildContext context) {
    final restaurant = widget.restaurant;
    final Polygon polygon = Polygon(polygonId: PolygonId("valuepoly"));
    Marker restaurantMarker = Marker(
        markerId: MarkerId(restaurant.restaurantId),
        position: LatLng(restaurant.lat, restaurant.long),
        infoWindow: InfoWindow(
          title: restaurant.name,
        ),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange));
    Marker anotherMarker = Marker(
        markerId: MarkerId(restaurant.restaurantId),
        position: LatLng(restaurant.lat + 10, restaurant.long + 12),
        infoWindow: InfoWindow(
          title: restaurant.name,
        ),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Get Directions"),
        actions: [
          TextButton(
              child: Text("Directions"),
              onPressed: () {
                debugPrint("show directions");
              })
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: initialCameraPosition,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (controller) => googleMapController = controller,
            polylines: {
              Polyline(
                polylineId: PolylineId("value"),
                points: [
                  LatLng(restaurant.lat, restaurant.long),
                  LatLng(restaurant.lat + .92, restaurant.long + 1.2)
                ],
                width: 5,
              )
            },
            markers: {restaurantMarker},
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () => googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(initialCameraPosition)),
          child: Icon(Icons.center_focus_strong)),
    );
  }
}
