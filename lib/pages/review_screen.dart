import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../models/review_models.dart';
import '../providers/reviews.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen(
      {Key? key,
      required this.name,
      required this.foodId,
      required this.totalReviews,
      required this.provider})
      : super(key: key);
  final String foodId;
  final String name;
  final int totalReviews;
  final ReviewProvider provider;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(scrollListener);
    widget.provider.fetchNextReviews(foodId: widget.foodId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      debugPrint("load reviews");
      if (widget.provider.hasNext) {
        widget.provider.fetchNextReviews(foodId: widget.foodId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: CustomScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            dragStartBehavior: DragStartBehavior.down,
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close_rounded,
                      ))
                ],
                title: Text("All Reviews"),
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                expandedHeight: 160.0,
                centerTitle: true,
                forceElevated: false,
                elevation: 0.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Theme.of(context).primaryColor,
                            size: 77.0,
                          ),
                          Text(widget.totalReviews.toString())
                        ],
                      ),
                      SizedBox(
                        width: size.width * .65,
                        child: Text(
                          widget.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 24.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  ReviewModel item = widget.provider.reviews[index];
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: item.avatar,
                                      alignment: Alignment.center,
                                      fit: BoxFit.cover,
                                      errorWidget: (_, __, ___) => Lottie.asset(
                                          "assets/no-connection.json"),
                                      placeholder: (
                                        _,
                                        __,
                                      ) =>
                                          Lottie.asset("assets/loading7.json"),
                                      fadeInCurve:
                                          Curves.fastLinearToSlowEaseIn,
                                      width: 45.0,
                                      height: 45.0,
                                    ),
                                  ),
                                ),
                                Text(
                                  item.username,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.delete_rounded, size: 15),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    for (var i = 0; i < 5; i++)
                                      Icon(
                                        Icons.star_rounded,
                                        color: i <= item.rating
                                            ? Colors.green
                                            : Colors.grey.withOpacity(.3),
                                        size: 15.0,
                                      ),
                                  ],
                                ),
                              ),
                              Text(
                                item.created_at.day.toString() +
                                    "/" +
                                    item.created_at.month.toString() +
                                    "/" +
                                    item.created_at.year.toString(),
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                            width: size.width - ((size.width / 30) * 2),
                            child: Text(item.description))
                      ],
                    ),
                  );
                }, childCount: widget.provider.reviews.length),
              )
            ],
          ),
        ),
      ),
    );
  }
}
