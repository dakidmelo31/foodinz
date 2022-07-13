import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestaurantMap extends StatefulWidget {
  const RestaurantMap({Key? key, required this.lat, required this.long})
      : super(key: key);
  final double lat, long;

  @override
  State<RestaurantMap> createState() => _RestaurantMapState();
}

class _RestaurantMapState extends State<RestaurantMap> {
  late GoogleMapController _googleMapController;
  late CameraPosition _initialCameraPosition;
  @override
  void initState() {
    _initialCameraPosition = CameraPosition(
        target: LatLng(widget.lat, widget.long), zoom: 15.0, tilt: 50);
    super.initState();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.width * .7,
      width: size.width,
      child: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        buildingsEnabled: true,
        mapType: MapType.normal,
        indoorViewEnabled: true,
        onMapCreated: (controller) => _googleMapController = controller,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
