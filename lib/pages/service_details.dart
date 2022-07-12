import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/models/service.dart';
import 'package:foodinz/providers/global_data.dart';
import 'package:foodinz/providers/services.dart';
import 'package:like_button/like_button.dart';
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
    final _services = Provider.of<ServicesData>(context, listen: true);
    return Scaffold(
        backgroundColor: Colors.blue,
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
                        color: Colors.white,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Likes",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  LikeButton(
                                    animationDuration:
                                        const Duration(milliseconds: 600),
                                    bubblesColor: const BubblesColor(
                                        dotPrimaryColor: Colors.pink,
                                        dotSecondaryColor: Colors.orange),
                                    isLiked: false,
                                    likeCount: widget.service.likes,
                                    circleSize: 40.0,
                                    likeCountAnimationType:
                                        LikeCountAnimationType.part,
                                    countBuilder: (_, liked, data) {
                                      if (liked) {
                                        _services.toggleFavorite(
                                            widget.service.serviceId);
                                        debugPrint("toggled it");
                                      }
                                    },
                                  ),
                                ],
                              ),
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
                                        Icon(Icons.star_rounded,
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
                                    "Directions",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      debugPrint("add reviews");
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.directions_rounded,
                                            color: Colors.pink),
                                        Text(widget.service.comments.toString())
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
                ))
          ],
        ));
  }
}
