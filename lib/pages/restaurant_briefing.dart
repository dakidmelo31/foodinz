import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:foodinz/models/restaurants.dart';

import '../widgets/recent_comments.dart';
import '../widgets/restaurant_info_table.dart';

class RestaurantOverlay extends StatefulWidget {
  const RestaurantOverlay(
      {Key? key,
      required this.lat,
      required this.long,
      required this.restaurant})
      : super(key: key);
  final Restaurant restaurant;
  final double lat;
  final double long;

  @override
  State<RestaurantOverlay> createState() => _RestaurantOverlayState();
}

class _RestaurantOverlayState extends State<RestaurantOverlay> {
  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final w = size.width, h = size.height;
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(.82),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: kToolbarHeight * 2,
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Container(
                alignment: Alignment.center,
                width: size.width,
                height: size.height * .45,
                color: Colors.grey,
                child: GoogleMap(
                    mapToolbarEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: true,
                    buildingsEnabled: true,
                    zoomGesturesEnabled: true,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(
                      3,
                      34,
                    )),
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    markers: {
                      map.Marker(
                        markerId: MarkerId(widget.restaurant.restaurantId),
                        infoWindow:
                            InfoWindow(title: widget.restaurant.companyName),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueViolet),
                        position: LatLng(
                          widget.restaurant.lat,
                          widget.restaurant.long,
                        ),
                      ),
                      map.Marker(
                        markerId: MarkerId("myLocation"),
                        infoWindow: InfoWindow(
                          title: "You",
                        ),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRose),
                        position: LatLng(
                          widget.lat,
                          widget.long,
                        ),
                      ),
                    },
                    mapType: MapType.normal,
                    indoorViewEnabled: true),
              ),
            ),
            Card(
              color: Colors.white,
              elevation: 15,
              shadowColor: Colors.grey.withOpacity(.25),
              margin: EdgeInsets.symmetric(
                horizontal: w * 0.03,
                vertical: 10,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.1,
                  vertical: 10,
                ),
                child: RestaurantInfoTable(restaurant: widget.restaurant),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              widget.restaurant.companyName,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w300,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0, bottom: 10.0),
              child: Text(
                "Recent Comments",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 15.0, left: 10.0, bottom: 10.0),
              child: RecentComments(
                  restaurantId: widget.restaurant.restaurantId, isMeal: false),
            ),
            const SizedBox(height: 20)
          ],
        ));
  }
}
