import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/directions.dart';
import '../models/directions_repository.dart';
import '../models/restaurants.dart';
import '../models/user.dart';

class SeeLocation extends StatefulWidget {
  const SeeLocation({
    Key? key,
    required this.restaurant,
    required this.me,
  }) : super(key: key);
  final Restaurant restaurant;
  final UserModel me;

  @override
  State<SeeLocation> createState() => _SeeLocationState();
}

class _SeeLocationState extends State<SeeLocation> {
  loadDirections() async {
    debugPrint("Started loading directions");

    final directions = await DirectionsRepository(dio: Dio())
        .getDirections(source: source, destination: destination);
    debugPrint(directions.toString());
    setState(() {
      info = directions;
    });
  }

  List<LatLng> routeCoords = [];
  late CameraPosition initialCameraPosition;
  late GoogleMapController _mapController;
  @override
  void initState() {
    initPoints();
    initialCameraPosition = CameraPosition(
      target: LatLng(4.163, 9.2411677),
      zoom: 14.0,
      tilt: 50,
    );
    loadDirections();
    debugPrint("done loading directions");
    debugPrint("source: Lat " + source.latitude.toString());
    debugPrint("source: Lng " + source.latitude.toString());
    debugPrint("Destination: Lat " + destination.latitude.toString());
    debugPrint("Destination: Lng " + destination.longitude.toString());

    super.initState();
  }

  double lat = 0.0, lng = 0.0;

  Future<void> getLocation() async {
    var locationStatus = await Permission.location.status;
    if (locationStatus.isGranted) {
      debugPrint("granted");
    } else if (locationStatus.isDenied) {
      debugPrint("Not granted");
      Map<Permission, PermissionStatus> status =
          await [Permission.location].request();
    } else if (locationStatus.isPermanentlyDenied) {
      openAppSettings().then((value) {
        setState(() {});
      });
    }
    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    var lastPosition = await Geolocator.getLastKnownPosition();
    print("position is $lastPosition");

    setState(() {
      lat = position.latitude;
      lng = position.longitude;
    });
    debugPrint("latitude: $lat, and logitude: $lng");
  }

  initPoints() {
    source = LatLng(widget.restaurant.lat, widget.restaurant.lng);

    destination = LatLng(widget.me.lat, widget.me.lng);
  }

  static const String googleApiKey = "AIzaSyBW83ZgIKbFvy9Dzc6AkzQjd4ScIpXDrUM";

  late LatLng source;
  late LatLng destination;
  List<LatLng> polylineCoordinates = [];

  Directions? info;
  drawPlot() async {}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: Text("Location"),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _mapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: source,
                          zoom: 14.0,
                          tilt: 50,
                        ),
                      ),
                    );
                  });
                },
                child: Text(
                  "You",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _mapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: destination,
                          zoom: 14.0,
                          tilt: 50,
                        ),
                      ),
                    );
                  });
                },
                child: Text(
                  "Customer",
                  style: TextStyle(color: Colors.lightGreen),
                ),
              ),
            ]),
        body: Stack(
          children: [
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                bottom: 0,
                child: Container(
                  width: size.width,
                  height: size.height,
                  child: GoogleMap(
                    buildingsEnabled: false,
                    initialCameraPosition: initialCameraPosition,
                    mapType: MapType.normal,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    trafficEnabled: false,
                    indoorViewEnabled: false,
                    onMapCreated: (controller) => _mapController = controller,
                    polylines: {
                      Polyline(
                        polylineId: PolylineId("route"),
                        points: info != null
                            ? info!.polylinePoints
                                .map((e) => LatLng(e.latitude, e.longitude))
                                .toList()
                            : [],
                        width: 6,
                        color: Colors.lightGreen,
                        visible: true,
                      ),
                    },
                    markers: {
                      Marker(
                          infoWindow: InfoWindow(title: "You"),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueBlue),
                          markerId: MarkerId('markerId'),
                          position: initialCameraPosition.target),
                      Marker(
                          infoWindow: InfoWindow(title: "Customer"),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueGreen),
                          markerId: MarkerId('markerId'),
                          position: destination),
                    },
                  ),
                )),
            if (info != null)
              Align(
                alignment: Alignment.topCenter,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(info!.totalDistance),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
