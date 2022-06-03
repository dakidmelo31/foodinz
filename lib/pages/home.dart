import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodinz/pages/cart_screen.dart';
import 'package:foodinz/pages/messages_overview.dart';
import 'package:foodinz/pages/recent_contacts.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import '../global.dart';
import '../widgets/home_screen.dart';
import 'my_favorites.dart';
import 'my_settings.dart';

//
//Example to setup Stylish Bottom Bar with PageView
class Home extends StatefulWidget {
  static const routeName = "/home";
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  bool uploading = false;
  int _pageIndex = 0;
  final List<Widget> pages = [
    const HomeScreen(),
    const MessagesOverview(),
    const MyFavorites(),
    const MySettings(),
  ];

  var heart = false;
  late AnimationController _animationController;
  PageController controller = PageController(initialPage: 0);
  @override
  void initState() {
    // auth.signOut();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Duration transitionDuration = Duration(milliseconds: 500);
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus();
        },
        child: PageView(
          physics: const BouncingScrollPhysics(),
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
      ),
      bottomNavigationBar: StylishBottomBar(
        inkEffect: true,
        padding: const EdgeInsets.symmetric(horizontal: 4),
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
              'History',
            ),
          ),
          AnimatedBarItems(
            icon: const Icon(Icons.favorite_border_rounded),
            selectedIcon: const FaIcon(FontAwesomeIcons.heart),
            backgroundColor: Colors.blue,
            selectedColor: Colors.pink,
            title: const Text(
              'Favorites',
            ),
          ),
          AnimatedBarItems(
              icon: const Icon(Icons.person),
              selectedIcon: const FaIcon(FontAwesomeIcons.gear),
              backgroundColor: Colors.amber,
              selectedColor: Colors.pinkAccent,
              title: const Text('Settings')),
        ],
        iconSize: 16,
        barAnimation: BarAnimation.transform3D,
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
          Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 400),
                reverseTransitionDuration: const Duration(milliseconds: 400),
                pageBuilder: (context, animation, secondaryAnimation) {
                  return ScaleTransition(
                    filterQuality: FilterQuality.high,
                    scale: animation,
                    alignment: Alignment.bottomRight,
                    child: const CartScreen(),
                  );
                },
              )).then((value) {
            debugPrint("done with cart");
          });
        },
        backgroundColor: Colors.white,
        child: Icon(
          heart ? CupertinoIcons.shopping_cart : CupertinoIcons.shopping_cart,
          color: Theme.of(context).primaryColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
