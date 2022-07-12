import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/models/service.dart';

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
    return Scaffold(
        backgroundColor: Colors.blue,
        body: CustomScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: size.height * .5,
              elevation: 0.0,
              forceElevated: false,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              ),
              pinned: true,
              floating: true,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: [
                  StretchMode.blurBackground,
                  StretchMode.fadeTitle,
                  StretchMode.zoomBackground
                ],
                collapseMode: CollapseMode.parallax,
                background: Hero(
                  tag: widget.tag,
                  child: CachedNetworkImage(
                    imageUrl: widget.service.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
