import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:foodinz/models/restaurants.dart';
import 'package:foodinz/models/service.dart';
import 'package:foodinz/providers/data.dart';
import 'package:foodinz/providers/global_data.dart';
import 'package:foodinz/providers/services.dart';
import 'package:foodinz/themes/light_theme.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
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

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 245, 245, 245),
        body: CustomScrollView(
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    "Reviews",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      debugPrint("add reviews");
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(Icons.star_rounded,
                                            color: Colors.amber),
                                        Text(widget.service.comments.toString())
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text(
                                    "Direction",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
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
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: image,
                              fadeInCurve: Curves.bounceIn,
                              fadeOutCurve: Curves.bounceOut,
                              alignment: Alignment.center,
                              fit: BoxFit.cover,
                              placeholder: (_, stackTrace) => Lottie.asset(
                                "assets/loading5.json",
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),
                              filterQuality: FilterQuality.high,
                              errorWidget: (_, string, stackTrace) {
                                return Lottie.asset(
                                    "assets/no-connection2.json");
                              },
                            ),
                          ),
                        );
                      })
                ],
              ),
            )
          ],
        ));
  }
}
