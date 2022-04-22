import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../theme/main_theme.dart';
import 'all_chats.dart';

class MessagesOverview extends StatefulWidget {
  const MessagesOverview({Key? key}) : super(key: key);

  @override
  State<MessagesOverview> createState() => _MessagesOverviewState();
}

class _MessagesOverviewState extends State<MessagesOverview>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> progressAnimation;
  late ScrollController _sliverController;
  double _scroll_value = 0;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _sliverController =
        ScrollController(keepScrollOffset: true, initialScrollOffset: 0.0);
    _animationController.forward();

    _sliverController.addListener(() {
      _scroll_value = _sliverController.position.maxScrollExtent;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final faker = Faker();
    bool _showCancelled = true,
        _showPending = true,
        _showReady = true,
        _showAll = true,
        _showComplete = true,
        _showProcessing = true;
    final TabController tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
      animationDuration: Duration(
        milliseconds: 400,
      ),
    );

    List<String> list = List.generate(300, (index) => faker.lorem.sentence());
    return Scaffold(
      body: SafeArea(
        child: Stack(alignment: Alignment.topCenter, children: [
          Positioned(
            top: 0,
            left: 0,
            height: 130,
            width: size.width,
            child: TweenAnimationBuilder(
              duration: const Duration(milliseconds: 2400),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: CurvedAnimation(
                      parent: _animationController, curve: Curves.bounceIn)
                  .curve,
              builder: (context, double value, child) {
                return Opacity(opacity: value, child: child);
              },
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    const Spacer(),
                    Row(
                      children: [
                        IconButton(
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                            ),
                            onPressed: () {
                              Navigator.maybePop(context);
                            }),
                        Flexible(
                            child: Material(
                          elevation: 10,
                          shadowColor: Colors.grey.withOpacity(.3),
                          child: InkWell(
                            onTap: () {},
                            child: const TextField(
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                border: InputBorder.none,
                                hintText: "Search Order...",
                              ),
                            ),
                          ),
                        )),
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.filter,
                              size: 22, color: Colors.blue),
                          onPressed: () {
                            showBarModalBottomSheet(
                                animationCurve: Curves.elasticInOut,
                                duration: const Duration(milliseconds: 700),
                                bounce: true,
                                isDismissible: true,
                                elevation: 10,
                                enableDrag: true,
                                backgroundColor: Colors.blue.withOpacity(.4),
                                secondAnimation: _animationController,
                                context: context,
                                builder: (_) {
                                  return StatefulBuilder(
                                      builder: (_, setState) {
                                    _showAll = _showPending &&
                                        _showProcessing &&
                                        _showComplete &&
                                        _showReady &&
                                        _showCancelled;
                                    return SizedBox(
                                      width: size.width,
                                      height: size.height * .6,
                                      child: Column(children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (_showAll) {
                                                _showCancelled = false;
                                                _showPending = false;
                                                _showReady = false;
                                                _showAll = false;
                                                _showComplete = false;
                                                _showProcessing = false;
                                              } else {
                                                _showCancelled = true;
                                                _showPending = true;
                                                _showReady = true;
                                                _showAll = true;
                                                _showComplete = true;
                                                _showProcessing = true;
                                              }
                                              _showAll = !_showAll;
                                            });
                                          },
                                          child: SizedBox(
                                            height: size.height * .1,
                                            width: size.width,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text("Show all orders",
                                                      style: heading),
                                                  Switch.adaptive(
                                                    value: _showAll,
                                                    onChanged: (onChanged) {
                                                      debugPrint("toggle on");
                                                      setState(() {
                                                        if (_showAll) {
                                                          _showCancelled =
                                                              false;
                                                          _showPending = false;
                                                          _showReady = false;
                                                          _showAll = false;
                                                          _showComplete = false;
                                                          _showProcessing =
                                                              false;
                                                        } else {
                                                          _showCancelled = true;
                                                          _showPending = true;
                                                          _showReady = true;
                                                          _showAll = true;
                                                          _showComplete = true;
                                                          _showProcessing =
                                                              true;
                                                        }
                                                        _showAll = !_showAll;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _showPending = !_showPending;
                                            });
                                          },
                                          child: SizedBox(
                                            height: size.height * .1,
                                            width: size.width,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text("Pending",
                                                      style: heading),
                                                  Switch.adaptive(
                                                    value: _showPending,
                                                    onChanged: (onChanged) {
                                                      setState(() {
                                                        _showPending =
                                                            !_showPending;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _showProcessing =
                                                  !_showProcessing;
                                            });
                                          },
                                          child: SizedBox(
                                            height: size.height * .1,
                                            width: size.width,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text("Processing",
                                                      style: heading),
                                                  Switch.adaptive(
                                                    value: _showProcessing,
                                                    onChanged: (onChanged) {
                                                      setState(() {
                                                        _showProcessing =
                                                            !_showProcessing;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _showReady = !_showReady;
                                            });
                                          },
                                          child: SizedBox(
                                            height: size.height * .1,
                                            width: size.width,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text("Ready",
                                                      style: heading),
                                                  Switch.adaptive(
                                                    value: _showReady,
                                                    onChanged: (onChanged) {
                                                      setState(() {
                                                        _showComplete =
                                                            !_showComplete;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _showComplete = !_showComplete;
                                            });
                                          },
                                          child: SizedBox(
                                            height: size.height * .1,
                                            width: size.width,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text("Complete",
                                                      style: heading),
                                                  Switch.adaptive(
                                                    value: _showComplete,
                                                    onChanged: (onChanged) {
                                                      setState(() {
                                                        _showComplete =
                                                            !_showComplete;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _showCancelled = !_showCancelled;
                                            });
                                          },
                                          child: SizedBox(
                                            height: size.height * .1,
                                            width: size.width,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text("Deleted",
                                                      style: heading),
                                                  Switch.adaptive(
                                                    value: _showCancelled,
                                                    onChanged: (onChanged) {
                                                      setState(() {
                                                        _showCancelled =
                                                            !onChanged;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                    );
                                  });
                                });
                          },
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      height: kToolbarHeight,
                      width: size.width,
                      child: TabBar(
                        controller: tabController,
                        automaticIndicatorColorAdjustment: true,
                        isScrollable: true,
                        tabs: [
                          Tab(
                            icon: Icon(Icons.message_rounded),
                            child: Text("Messages"),
                          ),
                          Tab(
                            icon: Icon(Icons.restaurant_menu),
                            child: Text("Orders"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              top: 130,
              height: size.height - 130,
              width: size.width,
              left: 0,
              child: TabBarView(
                controller: tabController,
                children: [
                  CustomScrollView(
                    controller: _sliverController,
                    scrollDirection: Axis.vertical,
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            const SizedBox(height: 25),
                            const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: const Text("Showing All Orders",
                                  style: heading),
                            ),
                            Column(
                              children: list.map((e) {
                                return SizedBox(
                                  width: size.width,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Dismissible(
                                      key: GlobalKey(),
                                      background: Container(
                                          color: const Color.fromARGB(
                                              255, 43, 146, 39),
                                          child: const Icon(
                                            Icons.home,
                                            color: Colors.white,
                                          )),
                                      behavior: HitTestBehavior.deferToChild,
                                      direction: DismissDirection.horizontal,
                                      secondaryBackground: Container(
                                          color: Colors.deepPurple,
                                          child: const Icon(
                                            Icons.home,
                                            color: Colors.white,
                                          )),
                                      child: InkWell(
                                        splashColor: const Color.fromARGB(
                                            26, 59, 4, 209),
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          debugPrint("showDetails");
                                          Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                  transitionDuration:
                                                      const Duration(
                                                          milliseconds: 400),
                                                  reverseTransitionDuration:
                                                      const Duration(
                                                          milliseconds: 400),
                                                  opaque: false,
                                                  pageBuilder: (_,
                                                      _animationController,
                                                      secondary) {
                                                    return FadeTransition(
                                                        opacity:
                                                            _animationController,
                                                        child:
                                                            const ChatScreen());
                                                  }));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14.0, horizontal: 3),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 12.0),
                                                  child: CircleAvatar(
                                                    backgroundColor: Random()
                                                            .nextBool()
                                                        ? Colors.deepPurple
                                                        : Random().nextBool()
                                                            ? Colors.blue
                                                            : Random()
                                                                    .nextBool()
                                                                ? Colors.orange
                                                                : Random()
                                                                        .nextBool()
                                                                    ? Colors
                                                                        .pink
                                                                    : Colors
                                                                        .grey,
                                                    child: Icon(
                                                      Random().nextBool()
                                                          ? Icons
                                                              .supervised_user_circle
                                                          : Icons.chair_rounded,
                                                      color: Random().nextBool()
                                                          ? Colors.black
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 8.0,
                                                                horizontal: 0),
                                                        child: Text(e,
                                                            style: heading),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 4.0),
                                                        child: Text(
                                                          faker.lorem
                                                              .words(Random()
                                                                  .nextInt(12))
                                                              .join(" "),
                                                          style: TextStyle(
                                                            color: Colors.black
                                                                .withOpacity(
                                                              .8,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const FittedBox(
                                                        child: Text("12 Jun",
                                                            style: smallText)),
                                                    IconButton(
                                                        icon: const Icon(Icons
                                                            .star_border_rounded),
                                                        iconSize: 24,
                                                        onPressed: () {}),
                                                  ],
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Center(child: Text("show me the information"))
                ],
              ))
        ]),
      ),
    );
  }
}
