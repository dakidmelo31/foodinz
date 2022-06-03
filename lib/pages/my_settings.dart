import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/global.dart';
import 'package:foodinz/pages/login.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';

import 'crop_image.dart';

class MySettings extends StatefulWidget {
  const MySettings({
    Key? key,
  }) : super(key: key);

  @override
  State<MySettings> createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> snapshot;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  late GoogleMapController _mapController;
  bool editing = false;
  double long = 0, lat = 0;
  @override
  void dispose() {
    super.dispose();
  }

  bool darkMode = false;
  checkUser() {
    if (auth.currentUser == null) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              FadeTransition(
            opacity: animation,
            child: const Login(),
          ),
        ),
      );
    }
  }

  final formKey = GlobalKey<FormState>();
  bool updateOnce = false;
  @override
  void initState() {
    checkUser();
    super.initState();
    snapshot =
        firestore.collection("users").doc(auth.currentUser!.uid).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            child: StreamBuilder<DocumentSnapshot>(
                stream: snapshot,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text("please logout and sign in again"));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Lottie.asset("assets/loading2.json",
                          width: size.width * .8,
                          height: size.height * .8,
                          fit: BoxFit.contain,
                          reverse: true),
                    );
                  }
                  DocumentSnapshot user = snapshot.data;
                  if (!editing) {
                    _addressController.text = user['address'];
                    _nameController.text = user['name'];
                    _emailController.text = user['email'];
                    long = user['long'];
                    lat = user['lat'];
                  }
                  return Expanded(
                    child: Form(
                      key: formKey,
                      child: ListView(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 28.0),
                              child: SizedBox(
                                width: size.width,
                                height: size.width * .65,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    ClipOval(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15.0),
                                        child: ClipOval(
                                          child: Container(
                                            color: Colors.white,
                                            width: size.width * .5,
                                            height: size.width * .5,
                                            child: Center(
                                              child: Hero(
                                                tag: auth.currentUser!.uid,
                                                child: ClipOval(
                                                  child: InkWell(
                                                    onTap: () {
                                                      showCupertinoDialog(
                                                          barrierDismissible:
                                                              true,
                                                          barrierLabel:
                                                              "Profile Picture",
                                                          context: context,
                                                          builder: (_) {
                                                            return Center(
                                                              child: SizedBox(
                                                                height:
                                                                    size.width -
                                                                        100,
                                                                width:
                                                                    size.width -
                                                                        100,
                                                                child: Hero(
                                                                  tag: auth
                                                                      .currentUser!
                                                                      .uid,
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl: user[
                                                                        'image'],
                                                                    width:
                                                                        size.width *
                                                                            .4,
                                                                    height:
                                                                        size.width *
                                                                            .4,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    placeholder:
                                                                        (_, data) =>
                                                                            Shimmer(
                                                                      gradient:
                                                                          const LinearGradient(
                                                                              colors: [
                                                                            Color.fromARGB(
                                                                                255,
                                                                                225,
                                                                                225,
                                                                                225),
                                                                            Colors.white,
                                                                          ]),
                                                                      direction:
                                                                          ShimmerDirection
                                                                              .ltr,
                                                                      enabled:
                                                                          true,
                                                                      period: const Duration(
                                                                          milliseconds:
                                                                              600),
                                                                      child: Lottie
                                                                          .asset(
                                                                        "assets/loading7.json",
                                                                        width:
                                                                            90,
                                                                        height:
                                                                            90,
                                                                      ),
                                                                    ),
                                                                    errorWidget: (_,
                                                                            __,
                                                                            ___) =>
                                                                        Lottie
                                                                            .asset(
                                                                      "assets/no-connection3.json",
                                                                      width: 90,
                                                                      height:
                                                                          90,
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                    },
                                                    child: CachedNetworkImage(
                                                      imageUrl: user['image'],
                                                      width: size.width * .4,
                                                      height: size.width * .4,
                                                      fit: BoxFit.cover,
                                                      alignment:
                                                          Alignment.center,
                                                      placeholder: (_, data) =>
                                                          Shimmer(
                                                        gradient:
                                                            const LinearGradient(
                                                                colors: [
                                                              Color.fromARGB(
                                                                  255,
                                                                  225,
                                                                  225,
                                                                  225),
                                                              Colors.white,
                                                            ]),
                                                        direction:
                                                            ShimmerDirection
                                                                .ltr,
                                                        enabled: true,
                                                        period: const Duration(
                                                            milliseconds: 600),
                                                        child: Lottie.asset(
                                                          "assets/loading7.json",
                                                          width: 90,
                                                          height: 90,
                                                        ),
                                                      ),
                                                      errorWidget:
                                                          (_, __, ___) =>
                                                              Lottie.asset(
                                                        "assets/no-connection3.json",
                                                        width: 90,
                                                        height: 90,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: size.width * .25,
                                            bottom: 0.0),
                                        child: IconButton(
                                            onPressed: () async {
                                              bool? outcome =
                                                  await Navigator.push(
                                                      context,
                                                      PageTransition(
                                                          child:
                                                              const CropImage(),
                                                          type:
                                                              PageTransitionType
                                                                  .bottomToTop));

                                              if (outcome != null) {
                                                setState(() {});
                                              }
                                            },
                                            icon: const Icon(
                                                Icons.add_a_photo_rounded)),
                                      ),
                                    ),
                                    if (editing)
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: AvatarGlow(
                                          curve: Curves.decelerate,
                                          animate: true,
                                          duration: const Duration(
                                              milliseconds: 2700),
                                          repeatPauseDuration: const Duration(
                                              milliseconds: 1100),
                                          glowColor:
                                              Colors.blue.withOpacity(.15),
                                          endRadius: 40,
                                          repeat: true,
                                          shape: BoxShape.circle,
                                          showTwoGlows: true,
                                          child: IconButton(
                                            onPressed: () async {
                                              await firestore
                                                  .collection("users")
                                                  .doc(auth.currentUser!.uid)
                                                  .update(
                                                    {
                                                      "name":
                                                          _nameController.text,
                                                      "email":
                                                          _emailController.text,
                                                      "address":
                                                          _addressController
                                                              .text,
                                                      "lat": lat,
                                                      "long": long
                                                    },
                                                  )
                                                  .then(
                                                    (value) => debugPrint(
                                                        "Done Updating user"),
                                                  )
                                                  .catchError((onError) {
                                                    debugPrint(
                                                        "error found: $onError");
                                                  });
                                              setState(() {
                                                debugPrint(
                                                    "update user's information");
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.check_rounded,
                                              color: Colors.blue,
                                              size: 35,
                                            ),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ),
                            Center(
                              child: InkWell(
                                onTap: () {
                                  debugPrint("open dialpad");
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text(""),
                                    Text(
                                      user['phone'],
                                      style: const TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 30,
                                      ),
                                    ),
                                    const Icon(Icons.phone,
                                        color: Colors.greenAccent),
                                    const Text(""),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Card(
                              elevation: 10,
                              shadowColor: Colors.grey.withOpacity(.2),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: InkWell(
                                onTap: () {},
                                child: TextFormField(
                                  onChanged: (val) {
                                    setState(() {
                                      editing = true;
                                    });
                                  },
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Name",
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                  controller: _nameController,
                                ),
                              ),
                            ),
                            Card(
                              elevation: 10,
                              shadowColor: Colors.grey.withOpacity(.2),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 15.0),
                              child: InkWell(
                                onTap: () {},
                                child: TextFormField(
                                  onChanged: (val) {
                                    setState(() {
                                      editing = true;
                                    });
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Email",
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                  controller: _emailController,
                                ),
                              ),
                            ),
                            Card(
                              elevation: 10,
                              shadowColor: Colors.grey.withOpacity(.2),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 15.0),
                              child: InkWell(
                                onTap: () {},
                                child: TextFormField(
                                  onChanged: (val) {
                                    setState(() {
                                      editing = true;
                                    });
                                  },
                                  keyboardType: TextInputType.streetAddress,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Address",
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                  controller: _addressController,
                                ),
                              ),
                            ),
                            Card(
                                color: Colors.pink,
                                elevation: 12.0,
                                shadowColor: Colors.grey.withOpacity(.5),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: InkWell(
                                  onTap: (() {
                                    auth.signOut().then(
                                          (value) => Navigator.pushReplacement(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  FadeTransition(
                                                opacity: animation,
                                                child: const Login(),
                                              ),
                                            ),
                                          ),
                                        );
                                  }),
                                  child: SizedBox(
                                    width: 180.0,
                                    height: 60.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: const [
                                        Text("Logout",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600)),
                                        Icon(Icons.logout_rounded,
                                            color: Colors.white),
                                      ],
                                    ),
                                  ),
                                )),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              width: size.width,
                              height: size.height * .3,
                              child: GoogleMap(
                                mapType: MapType.normal,
                                mapToolbarEnabled: true,
                                scrollGesturesEnabled: true,
                                zoomControlsEnabled: true,
                                rotateGesturesEnabled: true,
                                myLocationEnabled: true,
                                myLocationButtonEnabled: true,
                                trafficEnabled: true,
                                onCameraMove: (position) {
                                  _mapController;
                                  setState(() {
                                    lat = position.target.latitude;
                                    long = position.target.longitude;
                                    if (!updateOnce) {
                                      updateOnce = true;
                                      Future.delayed(const Duration(seconds: 3),
                                          () async {
                                        await firestore
                                            .collection("users")
                                            .doc(auth.currentUser!.uid)
                                            .update(
                                          {"lat": lat, "long": long},
                                        ).then((value) => debugPrint(
                                                "done updating location"));
                                      });
                                    }
                                    debugPrint(
                                        "latitude: $lat; longitude: $long");
                                  });
                                },
                                initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                      user["lat"],
                                      user['long'],
                                    ),
                                    bearing: 50,
                                    zoom: 17.0,
                                    tilt: 50),
                                onMapCreated: (controller) =>
                                    _mapController = controller,
                                buildingsEnabled: true,
                                markers: {
                                  map.Marker(
                                    markerId: MarkerId(user.id),
                                    infoWindow: const InfoWindow(title: "You"),
                                    icon: BitmapDescriptor.defaultMarkerWithHue(
                                        BitmapDescriptor.hueViolet),
                                    position: LatLng(lat, long),
                                  )
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 60,
                            ),
                          ]),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
