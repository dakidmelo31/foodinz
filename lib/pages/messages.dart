import 'package:cached_network_image/cached_network_image.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodinz/pages/chat_screen.dart';
import 'package:lottie/lottie.dart';

import '../themes/light_theme.dart';

class AllMessages extends StatelessWidget {
  const AllMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: const AlwaysScrollableScrollPhysics(),
            ),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
          SliverAppBar(
            stretch: true,
            iconTheme: Theme.of(context).iconTheme,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: const Center(
              child: FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                color: Colors.black,
                size: 16,
              ),
            ),
            expandedHeight: 120,
            automaticallyImplyLeading: false,
            floating: true,
            onStretchTrigger: () {
              debugPrint("refresh chat");
              return Future(
                () => null,
              );
            },
            pinned: true,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text("Messages"),
              centerTitle: true,
              stretchModes: [StretchMode.fadeTitle, StretchMode.zoomBackground],
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: ClipOval(
                  child: CachedNetworkImage(
                      width: 54,
                      height: 54,
                      imageUrl:
                          "https://yt3.ggpht.com/pqdil0V03XEdFP-LHn6_vwVpHBRFjHt48kYcnBq8ycdgtfSEmZHIxqOU_PcVk8NarmYYHSpgPQ=s88-c-k-c0x00ffffff-no-rj-mo",
                      errorWidget: (_, string, stackTrace) =>
                          Lottie.asset("assets/no-connection3.json")),
                ),
              )
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(_delegate),
          )
        ]));
  }

  Widget _delegate(BuildContext context, int index) {
    final faker = Faker();
    String imageUrl = faker.image.image(random: true);
    String username = faker.person.name();
    final Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22.0),
      child: ListTile(
          onTap: () {
            const Duration transitionDuration = Duration(milliseconds: 400);
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: transitionDuration,
                reverseTransitionDuration: transitionDuration,
                pageBuilder: (_, animation, secondaryAnimation) {
                  return ScaleTransition(
                    scale: animation,
                    alignment: Alignment.centerRight,
                    filterQuality: FilterQuality.high,
                    child: const ChatScreen(),
                  );
                },
              ),
            );
          },
          leading: Hero(
            tag: imageUrl,
            child: InkWell(
              onTap: () {
                showDialog(
                    useSafeArea: true,
                    barrierDismissible: true,
                    barrierLabel: "Profile Photo",
                    context: context,
                    builder: (_) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hero(
                            tag: imageUrl,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                alignment: Alignment.center,
                                fit: BoxFit.cover,
                                width: 250,
                                height: 250,
                              ),
                            ),
                          ),
                          Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            color: Colors.white,
                            elevation: 10,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 200,
                                child: Column(
                                  children: [
                                    Text(username, style: Primary.heading),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.phone,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const FaIcon(
                                            FontAwesomeIcons.barsStaggered,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.delete_forever,
                                            color: Colors.deepOrange,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    });
              },
              child: ClipOval(
                child: CachedNetworkImage(
                  width: 54,
                  height: 54,
                  fit: BoxFit.cover,
                  imageUrl: imageUrl,
                ),
              ),
            ),
          ),
          title: Text(username, style: Primary.paragraph),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              faker.lorem.sentence(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 4.0),
              Text(
                faker.date.time(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
            ],
          )),
    );
  }
}
