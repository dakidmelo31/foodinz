import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:foodinz/global.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class RestaurantMap extends StatefulWidget {
  const RestaurantMap(
      {Key? key,
      required this.restaurantName,
      required this.lat,
      required this.long})
      : super(key: key);
  final double lat, long;
  final String restaurantName;

  @override
  State<RestaurantMap> createState() => _RestaurantMapState();
}

class _RestaurantMapState extends State<RestaurantMap> {
  late GoogleMapController _googleMapController;
  late CameraPosition _initialCameraPosition;
  double? myLat, myLng;
  @override
  void initState() {
    _initialCameraPosition = CameraPosition(
        target: LatLng(widget.lat, widget.long), zoom: 14.0, tilt: 50);
    getLocation();
    super.initState();
  }

  Future<void> getLocation() async {
    var locationStatus = await Permission.location.status;
    if (locationStatus.isGranted) {
      debugPrint("is granted");
    } else {
      if (locationStatus.isDenied) {
        debugPrint("Not granted");
        Map<Permission, PermissionStatus> status =
            await [Permission.location].request();
      } else {
        if (locationStatus.isPermanentlyDenied) {
          openAppSettings().then((value) {});
        }
      }
    }

    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    debugPrint("move the next step. again");
    debugPrint(position.toString());
    var lastPosition = await Geolocator.getLastKnownPosition();
    print("position is $lastPosition");

    myLat = position.latitude;
    myLng = position.longitude;
    debugPrint("latitude: $myLat, and logitude: $myLng");
    setState(() {});
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text("How far is it?"),
        ),
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: myLat == null
              ? loadingWidget
              : GoogleMap(
                  initialCameraPosition: _initialCameraPosition,
                  buildingsEnabled: true,
                  mapType: MapType.normal,
                  indoorViewEnabled: true,
                  onMapCreated: (controller) =>
                      _googleMapController = controller,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: {
                    Marker(
                      markerId: MarkerId("restaurantId"),
                      infoWindow: InfoWindow(title: widget.restaurantName),
                      position: LatLng(widget.lat, widget.long),
                    ),
                    Marker(
                      markerId: MarkerId("me"),
                      infoWindow: InfoWindow(
                        title: "Me",
                      ),
                      position: LatLng(myLat!, myLng!),
                    ),
                  },
                ),
        ),
      ),
    );
  }
}
