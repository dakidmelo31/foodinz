import 'dart:math';
import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodinz/models/user.dart';
import 'package:foodinz/pages/meal_details.dart';
import 'package:foodinz/pages/street_food.dart';
import 'package:foodinz/providers/category_serice.dart';
import 'package:foodinz/providers/meals.dart';
import 'package:foodinz/widgets/search_page.dart';
import 'package:foodinz/widgets/slideshows.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../models/food.dart';
import '../providers/auth.dart';
import '../providers/data.dart';
import '../themes/light_theme.dart';
import '../widgets/meals_block.dart';
import '../widgets/view_category.dart';
import 'restaurants_screen.dart';

class Showcase extends StatefulWidget {
  const Showcase({Key? key}) : super(key: key);

  @override
  State<Showcase> createState() => _ShowcaseState();
}

class _ShowcaseState extends State<Showcase> with TickerProviderStateMixin {
  UserModel? userInfo;
  late final PageController _cardPageController;
  late final PageController _cardDetailsController;
  late GoogleMapController _mapController;
  double _cardPage = 0.0, _cardDetailsPage = 0.0;
  int _cardIndex = 0;

  final _showCardDetails = ValueNotifier(true);
  @override
  void initState() {
    loadUser();
    getCurrentLocation();
    _cardPageController = PageController(viewportFraction: .77)
      ..addListener(_cardPageListener);
    _cardDetailsController = PageController()
      ..addListener(_cardDetailsPageListener);
    super.initState();
  }

  getCurrentLocation() async {
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

    lat = lastPosition!.latitude;
    long = lastPosition.longitude;
  }

  loadUser() async {
    final data = await FirebaseFirestore.instance
        .collection("users")
        .doc(auth.currentUser!.uid)
        .get();

    userInfo?.userId = data.id;
    userInfo?.address = data['address'];
    userInfo?.deviceToken = data['deviceToken'];
    userInfo?.email = data['email'];
    userInfo?.image = data['image'];
    userInfo?.lat = data['lat'];
    userInfo?.long = data['long'];
    userInfo?.name = data['name'];
    userInfo?.phone = data['phone'];
    debugPrint("User information found here: " + userInfo.toString());
    setState(() {});
  }

  final time = DateTime.now();
  late final greetings = time.hour < 12
      ? "Good morning"
      : time.hour < 16
          ? "Good afternoon"
          : "Good evening";
  double lat = 0.0, long = 0.0;

  _cardPageListener() {
    setState(() {
      _cardPage = _cardPageController.page!;
      _cardIndex = _cardPageController.page!.round();
    });
  }

  _cardDetailsPageListener() {
    setState(() {
      _cardDetailsPage = _cardDetailsController.page!;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mealsData = Provider.of<MealsData>(context);

    final _restaurantsData = Provider.of<RestaurantData>(context);
    final cafeMeals = mealsData.cafeMeals;
    final streetMeals = mealsData.streetMeals;
    final homeDelivery = mealsData.homeDelivery;
    final traditionalMeals = mealsData.traditionalMeals;
    final _categoryData = Provider.of<CategoryData>(context);

    final meals = mealsData.meals;
    final size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final h = constraints.maxHeight;
            final w = constraints.maxWidth;

            return GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus!.unfocus();
              },
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: ListView(
                  children: [
                    Container(
                        width: size.width,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 247, 244, 243),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Material(
                          elevation: 0,
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              debugPrint("move");
                              Navigator.push(
                                  context, FadeSearch(page: SearchScreen()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.search,
                                          size: 30, color: Colors.brown[700]),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          "Search",
                                          style: TextStyle(
                                              color: Colors.brown[700],
                                              fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: ClipOval(
                                      child: Container(
                                        color: Colors.white,
                                        width: 45,
                                        height: 45,
                                        child: Center(
                                          child: ClipOval(
                                            child: FutureBuilder<
                                                    DocumentSnapshot>(
                                                future: FirebaseFirestore
                                                    .instance
                                                    .collection("users")
                                                    .doc(auth.currentUser!.uid)
                                                    .get(),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasError ||
                                                      snapshot.connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                    return const Shimmer(
                                                        child: SizedBox(
                                                          width: 40,
                                                          height: 40,
                                                        ),
                                                        gradient:
                                                            LinearGradient(
                                                                colors: [
                                                              Colors.white,
                                                              Color.fromARGB(
                                                                  255,
                                                                  241,
                                                                  241,
                                                                  241)
                                                            ]));
                                                  }

                                                  Map<String, dynamic> data =
                                                      snapshot.data!.data()
                                                          as Map<String,
                                                              dynamic>;
                                                  return CachedNetworkImage(
                                                    imageUrl: data["image"],
                                                    width: 40,
                                                    height: 40,
                                                    placeholder: (_, __) =>
                                                        const Shimmer(
                                                            child: SizedBox(
                                                              width: 40,
                                                              height: 40,
                                                            ),
                                                            gradient:
                                                                LinearGradient(
                                                                    colors: [
                                                                  Colors.white,
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          241,
                                                                          241,
                                                                          241)
                                                                ])),
                                                    fit: BoxFit.cover,
                                                    alignment: Alignment.center,
                                                    errorWidget: (_, __, ___) =>
                                                        Lottie.asset(
                                                            "assets/waiting-pigeon.json"),
                                                  );
                                                }),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                    Column(
                      children: [
                        Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: 18.0, bottom: 15),
                                child: Text("Popular Meals",
                                    style: Primary.heading),
                              ),
                            ),
                            SizedBox(
                              height: h * .45,
                              width: w * .85,
                              child: PageView.builder(
                                physics: const BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics()),
                                controller: _cardPageController,
                                onPageChanged: (page) {
                                  _cardDetailsController.animateToPage(page,
                                      duration:
                                          const Duration(milliseconds: 550),
                                      curve: Curves.decelerate);
                                },
                                clipBehavior: Clip.none,
                                itemCount: meals.length,
                                itemBuilder: (_, index) {
                                  final Food meal = meals[index];
                                  final String myTag = meal.foodId +
                                      (Random().nextDouble() * 999999999999)
                                          .toString();
                                  final mealGallery = meal.gallery;
                                  final progress = (_cardPage - index);
                                  final scale =
                                      lerpDouble(1, .8, progress.abs())!;
                                  final isScrolling = _cardPageController
                                      .position.isScrollingNotifier.value;
                                  final isCurrentPage = index == _cardIndex;
                                  final isFirstPage = index == 0;
                                  return Transform.scale(
                                    alignment: Alignment.lerp(
                                        Alignment.centerLeft,
                                        Alignment.center,
                                        -progress),
                                    scale: isScrolling && isFirstPage
                                        ? 1 - progress
                                        : scale,
                                    child: GestureDetector(
                                      onTap: () {
                                        _showCardDetails.value =
                                            !_showCardDetails.value;
                                        const transitionDuration =
                                            Duration(milliseconds: 750);

                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration:
                                                transitionDuration,
                                            reverseTransitionDuration:
                                                transitionDuration,
                                            pageBuilder: (_, animation, __) {
                                              return FadeTransition(
                                                opacity: animation,
                                                child: SizeTransition(
                                                    axis: Axis.horizontal,
                                                    sizeFactor: CurvedAnimation(
                                                        parent: animation,
                                                        curve: const Interval(
                                                            .0, .80,
                                                            curve: Curves
                                                                .decelerate)),
                                                    child: FoodDetails(
                                                      meal: meal,
                                                      heroTag: myTag,
                                                    )),
                                              );
                                            },
                                          ),
                                        );
                                        Future.delayed(transitionDuration, () {
                                          _showCardDetails.value =
                                              !_showCardDetails.value;
                                        });
                                      },
                                      child: Hero(
                                        tag: myTag,
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 400),
                                          curve: Curves.easeInOut,
                                          transform: Matrix4.identity()
                                            ..translate(
                                              isCurrentPage ? 0.0 : -5.0,
                                              isCurrentPage ? 0.0 : 0.0,
                                            ),
                                          child: Material(
                                            shadowColor: index == _cardIndex
                                                ? const Color.fromARGB(
                                                    103, 0, 0, 0)
                                                : Colors.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    const Radius.circular(10)),
                                            elevation: 10,
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              child: GridTile(
                                                child: CachedNetworkImage(
                                                  imageUrl: meal.image,
                                                  alignment: Alignment.center,
                                                  fit: BoxFit.cover,
                                                  filterQuality:
                                                      FilterQuality.high,
                                                  errorWidget:
                                                      (_, string, stackTrace) {
                                                    return Lottie.asset(
                                                        "assets/no-connection2.json");
                                                  },
                                                ),
                                                footer: SizedBox(
                                                  height: size.height * .08,
                                                  width: double.infinity,
                                                  child: CarouselSlider.builder(
                                                    itemCount:
                                                        mealGallery.length,
                                                    itemBuilder:
                                                        (_, index, index2) {
                                                      return ClipOval(
                                                        child:
                                                            AnimatedContainer(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      400),
                                                          curve:
                                                              Curves.easeInOut,
                                                          transform:
                                                              Matrix4.identity()
                                                                ..translate(
                                                                  isCurrentPage
                                                                      ? 0.0
                                                                      : -5.0,
                                                                  isCurrentPage
                                                                      ? 0.0
                                                                      : 0.0,
                                                                ),
                                                          height:
                                                              size.height * .08,
                                                          width:
                                                              size.height * .08,
                                                          alignment:
                                                              Alignment.center,
                                                          color: Colors.white,
                                                          child: ClipOval(
                                                            child:
                                                                CachedNetworkImage(
                                                                    placeholder:
                                                                        (_, data) {
                                                                      return Lottie
                                                                          .asset(
                                                                              "assets/loading5.json");
                                                                    },
                                                                    height:
                                                                        size.height *
                                                                            .07,
                                                                    width:
                                                                        size.height *
                                                                            .07,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    imageUrl:
                                                                        mealGallery[
                                                                            index]),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    options: CarouselOptions(
                                                      viewportFraction: .33,
                                                      autoPlay: true,
                                                      enableInfiniteScroll:
                                                          true,
                                                      autoPlayInterval:
                                                          const Duration(
                                                              seconds: 6),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                        SizedBox(
                            height: h * .15,
                            child: PageView.builder(
                              itemCount: meals.length,
                              physics: const NeverScrollableScrollPhysics(),
                              controller: _cardDetailsController,
                              itemBuilder: (_, index) {
                                final Food meal = meals[index];
                                final opacity =
                                    (index - _cardDetailsPage).clamp(0.0, 1.0);
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w * 0.1,
                                  ),
                                  child: Opacity(
                                    opacity: 1 - opacity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Hero(
                                          tag: meal.foodId,
                                          child: FittedBox(
                                            child: Material(
                                              type: MaterialType.transparency,
                                              child: Text(
                                                meal.name.toUpperCase(),
                                                style: const TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        ValueListenableBuilder<bool>(
                                          valueListenable: _showCardDetails,
                                          builder: (_, value, child) {
                                            return Visibility(
                                              child: child!,
                                              visible: value,
                                            );
                                          },
                                          child: Text(
                                            meal.categories.join(","),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )),
                        const SizedBox(height: 10), // Cafe meals
                        OpenContainer(
                          closedElevation: 0,
                          openElevation: 0,
                          closedBuilder: (_, openContainer) => InkWell(
                            onTap: openContainer,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text("Popular Street Foods",
                                      style: Primary.heading),
                                  Icon(Icons.arrow_forward_rounded),
                                ],
                              ),
                            ),
                          ),
                          transitionDuration: const Duration(milliseconds: 700),
                          middleColor: Colors.orange,
                          transitionType: ContainerTransitionType.fadeThrough,
                          tappable: true,
                          openBuilder: (_, closedContainer) => ViewCategory(
                              mealCategory: cafeMeals, title: " Cafe Meals"),
                        ),
                        const StreetFood(),
                        const SizedBox(
                          height: 20,
                        ),
                        OpenContainer(
                          closedElevation: 0,
                          openElevation: 0,
                          closedBuilder: (_, openContainer) => InkWell(
                            onTap: openContainer,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text("Popular Restaurants",
                                      style: Primary.heading),
                                  Icon(Icons.arrow_forward_rounded),
                                ],
                              ),
                            ),
                          ),
                          transitionDuration: const Duration(milliseconds: 700),
                          middleColor: Colors.orange,
                          transitionType: ContainerTransitionType.fadeThrough,
                          tappable: true,
                          openBuilder: (_, closedContainer) => ViewCategory(
                              mealCategory: cafeMeals, title: "Popular"),
                        ),

                        SizedBox(
                            width: size.width,
                            height: size.height * .75,
                            child: RestaurantsScreen(lat: lat, long: long)),

                        const MealsBlock(
                            filter: "traditional", title: "Street Meals"),

                        const MealsBlock(filter: "cafe", title: "Cafe"),

                        const MealsBlock(
                            filter: "Traditional", title: "Traditional"),

                        const MealsBlock(filter: "Desserts", title: "Desserts"),

                        const ShowcaseSlideshow(),

                        const MealsBlock(filter: "grocery", title: "Groceries"),

                        SizedBox(
                          width: size.width,
                          height: size.height * .7,
                          child: Stack(
                            children: [
                              ClipPath(
                                clipper: ClipContainer(),
                                child: SizedBox(
                                  height: size.height * .6,
                                  width: size.width,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "https://media.istockphoto.com/photos/cropped-shot-of-an-africanamerican-young-woman-using-smart-phone-at-picture-id1313901506?b=1&k=20&m=1313901506&s=170667a&w=0&h=Dg9qzoAe0pYsBceTUZ6lzaWeUuG3ZQ2WZuLqXvYc718=",
                                    fit: BoxFit.cover,
                                    width: size.width,
                                    height: size.height * .6,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 30.0),
                                  child: Lottie.asset("assets/catering2.json",
                                      reverse: true,
                                      width: size.width * .3,
                                      height: size.width * .3,
                                      options:
                                          LottieOptions(enableMergePaths: true),
                                      fit: BoxFit.contain),
                                ),
                              ),
                              const Align(
                                alignment: Alignment.bottomCenter,
                                child: Text("You don't have to wait anymore.",
                                    style: Primary.heading),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class ClipContainer extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // path.quadraticBezierTo(300, 120, 0, size.height * .5);
    // path.lineTo(0, 0);

    // path.lineTo(size.width / 2, size.height);
    // path.lineTo(size.width, 0.0);

    // path.quadraticBezierTo(
    //     size.width / 3, size.height - 50, size.width, size.height);
    // path.lineTo(size.width, 0);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height - 200, size.width, size.height);
    path.lineTo(size.width, 0);
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class FadeSearch extends PageRouteBuilder {
  final Widget page;
  FadeSearch({required this.page})
      : super(
            pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) =>
                page,
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
                  opacity: animation,
                  child: page,
                ));
}
