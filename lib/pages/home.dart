import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      body: PageView(
        controller: controller,
        children: [
          HomeScreen()
          //Add(),
          //Profile(),
        ],
      ),
      bottomNavigationBar: StylishBottomBar(
        bubbleFillStyle: BubbleFillStyle.outlined,
        barStyle: BubbleBarStyle.horizotnal,
        items: [
          AnimatedBarItems(
              icon: Icon(
                Icons.house_outlined,
              ),
              selectedIcon: Icon(Icons.explore),
              selectedColor: Colors.deepOrange,
              backgroundColor: Colors.amber,
              title: Text('Explore')),
          AnimatedBarItems(
              icon: Icon(Icons.restaurant),
              selectedIcon: Icon(Icons.restaurant_menu),
              selectedColor: Colors.pink,
              backgroundColor: Colors.amber,
              title: Text('Restaurants')),
          AnimatedBarItems(
              icon: Icon(
                Icons.chat_bubble_outline,
              ),
              selectedIcon: Icon(
                Icons.support_agent_rounded,
              ),
              backgroundColor: Colors.blue,
              selectedColor: Colors.pink,
              title: Text('Support')),
          AnimatedBarItems(
              icon: Icon(
                Icons.person_outline,
              ),
              selectedIcon: Icon(
                Icons.person,
              ),
              backgroundColor: Colors.amber,
              selectedColor: Colors.pinkAccent,
              title: Text('Profile')),
        ],
        iconSize: 16,
        barAnimation: BarAnimation.liquid,
        iconStyle: IconStyle.animated,
        hasNotch: true,
        fabLocation: StylishBarFabLocation.end,
        opacity: 0.2,
        currentIndex: selected ?? 0,
        onTap: (index) {
          setState(() {
            selected = index;
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
