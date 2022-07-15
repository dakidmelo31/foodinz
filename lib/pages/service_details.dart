import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:foodinz/global.dart';
import 'package:foodinz/models/restaurants.dart';
import 'package:foodinz/models/service.dart';
import 'package:foodinz/pages/maps/single_map.dart';
import 'package:foodinz/pages/restaurant_details.dart';
import 'package:foodinz/providers/data.dart';
import 'package:foodinz/providers/global_data.dart';
import 'package:foodinz/providers/services.dart';
import 'package:foodinz/theme/main_theme.dart';
import 'package:foodinz/themes/light_theme.dart';
import 'package:foodinz/widgets/restaurant_info_table.dart';
import 'package:foodinz/widgets/transitions.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ServiceDetails extends StatefulWidget {
  const ServiceDetails({Key? key, required this.service, required this.tag})
      : super(key: key);
  final ServiceModel service;
  final String tag;

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _serviceData = Provider.of<ServicesData>(context, listen: true);
    final _restaurantData = Provider.of<RestaurantData>(context, listen: true);

    final List<ServiceModel> services = _serviceData.services;
    final List<Restaurant> restaurant = _restaurantData.restaurants;

    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 245, 245, 245),
          body: Column(
            children: [
              SizedBox(
                width: size.width,
                height: size.height - (kToolbarHeight * 2),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                    SliverAppBar(
                        backgroundColor: Colors.transparent,
                        expandedHeight: size.height * .5,
                        elevation: 0.0,
                        forceElevated: false,
                        automaticallyImplyLeading: false,
                        bottom: PreferredSize(
                          child: Container(),
                          preferredSize: const Size(0, 20),
                        ),
                        leading: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                          ),
                        ),
                        pinned: true,
                        floating: true,
                        stretch: true,
                        flexibleSpace: Stack(
                          children: [
                            Positioned(
                              child: Hero(
                                tag: widget.tag,
                                child: CachedNetworkImage(
                                  imageUrl: widget.service.image,
                                  fit: BoxFit.cover,
                                  width: size.width,
                                ),
                              ),
                              top: 0,
                              right: 0,
                              bottom: 0,
                              left: 0,
                            ),
                            Positioned(
                              child: Card(
                                elevation: 15.0,
                                color: Colors.white,
                                shadowColor: Colors.black.withOpacity(.3),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          const Text(
                                            "Reviews",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              debugPrint("add reviews");
                                            },
                                            child: Row(
                                              children: [
                                                const Icon(Icons.star_rounded,
                                                    color: Colors.amber),
                                                Text(widget.service.comments
                                                    .toString())
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            "Direction",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              debugPrint("Get Direction");
                                            },
                                            child: Row(
                                              children: const [
                                                Icon(Icons.directions_rounded,
                                                    color: Colors.pink),
                                                Text("Get Direction")
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              bottom: -1,
                              left: 0,
                              right: 0,
                            )
                          ],
                        )),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          ListTile(
                            title: Text(
                              widget.service.name,
                              style: Primary.heading,
                            ),
                            leading: const Icon(
                              Icons.room_service_rounded,
                            ),
                            subtitle: Text(
                              widget.service.description,
                            ),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.timer_rounded,
                            ),
                            title: Text(widget.service.duration),
                            trailing: const Icon(
                              Icons.check_rounded,
                              color: Colors.lightGreen,
                            ),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.location_on_outlined,
                              color: Colors.lightGreen,
                            ),
                            title: Text("Coverage: ${widget.service.coverage}"),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.attach_money_rounded,
                              color: Colors.lightGreen,
                            ),
                            title: Text(
                              widget.service.cost.isEmpty
                                  ? "0 CFA"
                                  : widget.service.cost,
                            ),
                          ),
                          const Center(
                            child: Text(
                              "See my work samples",
                              style: Primary.heading,
                            ),
                          ),
                          MasonryGridView.count(
                              itemCount: widget.service.gallery.length,
                              shrinkWrap: true,
                              addRepaintBoundaries: true,
                              primary: true,
                              crossAxisCount: 2,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (_, index) {
                                String image = widget.service.gallery[index];
                                String galleryTag =
                                    image + Random().nextInt(500).toString();
                                return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Hero(
                                      tag: galleryTag,
                                      child: Material(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              CustomFadeTransition(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Scaffold(
                                                    backgroundColor: Colors
                                                        .black
                                                        .withOpacity(.4),
                                                    body: Center(
                                                      child: Hero(
                                                        tag: galleryTag,
                                                        child: Material(
                                                          child: AbsorbPointer(
                                                            ignoringSemantics:
                                                                true,
                                                            absorbing: true,
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: image,
                                                              fadeInCurve: Curves
                                                                  .decelerate,
                                                              fadeOutCurve: Curves
                                                                  .decelerate,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              fit: BoxFit.cover,
                                                              placeholder: (_,
                                                                      stackTrace) =>
                                                                  Lottie.asset(
                                                                "assets/loading5.json",
                                                                fit: BoxFit
                                                                    .cover,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                              ),
                                                              filterQuality:
                                                                  FilterQuality
                                                                      .high,
                                                              errorWidget: (_,
                                                                  string,
                                                                  stackTrace) {
                                                                return Lottie.asset(
                                                                    "assets/no-connection2.json");
                                                              },
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
                                          child: CachedNetworkImage(
                                            imageUrl: image,
                                            fadeInCurve: Curves.bounceIn,
                                            fadeOutCurve: Curves.bounceOut,
                                            alignment: Alignment.center,
                                            fit: BoxFit.cover,
                                            placeholder: (_, stackTrace) =>
                                                Lottie.asset(
                                              "assets/loading5.json",
                                              fit: BoxFit.cover,
                                              alignment: Alignment.center,
                                            ),
                                            filterQuality: FilterQuality.high,
                                            errorWidget:
                                                (_, string, stackTrace) {
                                              return Lottie.asset(
                                                  "assets/no-connection2.json");
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Card(
                  elevation: 15.0,
                  margin: EdgeInsets.zero,
                  color: Colors.deepOrange,
                  child: InkWell(
                    onTap: () async {
                      Restaurant? parentRestaurant = _restaurantData
                          .getRestaurant(widget.service.restaurantId);
                      if (parentRestaurant.name.isEmpty) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Restaurant no more exists"),
                            elevation: 10.0,
                            backgroundColor: Colors.white,
                          ),
                        );
                        Navigator.pop(context);
                      }
                      showCupertinoModalBottomSheet(
                          context: context,
                          elevation: 15.0,
                          enableDrag: true,
                          expand: true,
                          isDismissible: true,
                          bounce: true,
                          backgroundColor: Colors.black.withOpacity(.3),
                          builder: (_) {
                            return Material(
                              color: Colors.transparent,
                              elevation: 0.0,
                              child: FractionallySizedBox(
                                heightFactor: 0.7,
                                widthFactor: 1.0,
                                alignment: Alignment.bottomCenter,
                                child: Card(
                                  color: Colors.white,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  child: Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Card(
                                          elevation: 15.0,
                                          shadowColor:
                                              Colors.black.withOpacity(.2),
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12.0,
                                                horizontal: 0.0),
                                            child: SizedBox(
                                              width: size.width,
                                              child: Text(parentRestaurant.name,
                                                  style: const TextStyle(
                                                      fontSize: 18.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                  textAlign: TextAlign.center),
                                            ),
                                          ),
                                        ),
                                        ClipOval(
                                          child: Hero(
                                            tag: widget.tag,
                                            child: CachedNetworkImage(
                                              imageUrl: parentRestaurant
                                                  .businessPhoto,
                                              alignment: Alignment.center,
                                              fit: BoxFit.cover,
                                              filterQuality: FilterQuality.high,
                                              placeholder: (_, __) =>
                                                  loadingWidget,
                                              errorWidget: (_, __, ___) =>
                                                  errorWidget2,
                                              width: size.width * .5,
                                              height: size.width * .5,
                                            ),
                                          ),
                                        ),
                                        Card(
                                            elevation: 15.0,
                                            shadowColor:
                                                Colors.black.withOpacity(.2),
                                            color: Colors.white,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12.0,
                                                      horizontal: 15.0),
                                              child: Text(
                                                widget.service.negociable
                                                    ? "My price is negociable"
                                                    : "I have a fixed Price",
                                              ),
                                            )),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        ListTile(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              VerticalSizeTransition(
                                                child: RestaurantMap(
                                                  lat: parentRestaurant.lat,
                                                  long: parentRestaurant.long,
                                                ),
                                              ),
                                            );
                                          },
                                          leading: Icon(
                                            Icons.map_rounded,
                                            color: Colors.pink,
                                          ),
                                          title: Text("Open your map"),
                                        ),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            FloatingActionButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  CustomFadeTransition(
                                                    child: RestaurantDetails(
                                                        restaurant:
                                                            parentRestaurant),
                                                  ),
                                                );
                                              },
                                              child: const Icon(
                                                  Icons.restaurant_outlined),
                                            ),
                                            FloatingActionButton(
                                              backgroundColor: Color.fromARGB(
                                                  255, 0, 167, 22),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  CustomFadeTransition(
                                                    child: RestaurantDetails(
                                                        restaurant:
                                                            parentRestaurant),
                                                  ),
                                                );
                                              },
                                              child: const Icon(
                                                Icons.whatsapp_rounded,
                                              ),
                                            ),
                                            FloatingActionButton(
                                              backgroundColor: Colors.white,
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  CustomFadeTransition(
                                                    child: RestaurantDetails(
                                                        restaurant:
                                                            parentRestaurant),
                                                  ),
                                                );
                                              },
                                              child: const Icon(
                                                Icons.phone_callback_rounded,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                      child: SizedBox(
                        child: const Center(
                            child: Text(
                          "Contact For Booking",
                          style: Primary.whiteText,
                        )),
                        width: size.width,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
