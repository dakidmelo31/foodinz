import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodinz/pages/all_orders.dart';
import 'package:foodinz/pages/calls.dart';
import 'package:foodinz/pages/messages.dart';
import 'package:foodinz/pages/messages_overview.dart';
import 'package:foodinz/pages/recent_contacts.dart';
import 'package:foodinz/pages/stories.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../widgets/home_screen.dart';

//
//Example to setup Stylish Bottom Bar with PageView
class Home extends StatefulWidget {
  static const routeName = "/home";
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var selected;
  int _pageIndex = 0;
  final List<Widget> pages = const [
    HomeScreen(),
    MessagesOverview(),
    AllMessages(),
    RecentContacts(),
    CallsScreen(),
  ];

  var bgColor;
  var heart = false;

  PageController controller = PageController(initialPage: 0);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Duration transitionDuration = Duration(milliseconds: 500);
    return Scaffold(
      body: PageView(
        physics: BouncingScrollPhysics(),
        pageSnapping: true,
        controller: controller,
        children: [
          AnimatedSwitcher(
              duration: transitionDuration,
              reverseDuration: transitionDuration,
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeIn,
              child: pages[_pageIndex])
        ],
      ),
      bottomNavigationBar: StylishBottomBar(
        bubbleFillStyle: BubbleFillStyle.outlined,
        elevation: 0,
        barStyle: BubbleBarStyle.horizotnal,
        items: [
          AnimatedBarItems(
            icon: const Icon(
              Icons.house_outlined,
            ),
            selectedIcon: const Icon(Icons.explore),
            selectedColor: Colors.deepOrange,
            backgroundColor: Colors.amber,
            title: const Text(
              'Explore',
            ),
          ),
          AnimatedBarItems(
            icon: const FaIcon(FontAwesomeIcons.clockRotateLeft),
            selectedIcon: const FaIcon(FontAwesomeIcons.clockRotateLeft),
            selectedColor: Colors.pink,
            backgroundColor: Colors.amber,
            title: const Text(
              'Orders',
            ),
          ),
          AnimatedBarItems(
            icon: const FaIcon(FontAwesomeIcons.message),
            selectedIcon: const FaIcon(FontAwesomeIcons.message),
            backgroundColor: Colors.blue,
            selectedColor: Colors.pink,
            title: const Text(
              'Support',
            ),
          ),
          AnimatedBarItems(
              icon: const FaIcon(FontAwesomeIcons.phoneFlip),
              selectedIcon: const FaIcon(FontAwesomeIcons.phoneFlip),
              backgroundColor: Colors.amber,
              selectedColor: Colors.pinkAccent,
              title: const Text('Calls')),
        ],
        iconSize: 16,
        barAnimation: BarAnimation.liquid,
        iconStyle: IconStyle.animated,
        hasNotch: true,
        fabLocation: StylishBarFabLocation.end,
        opacity: 0.2,
        currentIndex: _pageIndex,
        onTap: (index) {
          setState(() {
            _pageIndex = index!;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            heart = !heart;
          });
        },
        backgroundColor: Colors.white,
        child: Icon(
          heart ? CupertinoIcons.shopping_cart : CupertinoIcons.shopping_cart,
          color: Colors.red,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
