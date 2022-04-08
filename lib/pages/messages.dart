import 'package:cached_network_image/cached_network_image.dart';
import 'package:faker/faker.dart';
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
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Center(
            child: FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              color: Colors.black,
              size: 16,
            ),
          ),
          title: const Text("Messages"),
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
        body: CustomScrollView(slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(_delegate),
          )
        ]));
  }

  Widget _delegate(BuildContext context, int index) {
    final faker = Faker();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
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
                    child: ChatScreen(),
                  );
                },
              ),
            );
          },
          leading: ClipOval(
            child: CachedNetworkImage(
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              imageUrl: faker.image.image(),
            ),
          ),
          title: Text(faker.person.name(), style: Primary.paragraph),
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
              SizedBox(height: 4.0),
              Text(
                faker.date.time(),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
            ],
          )),
    );
  }
}
