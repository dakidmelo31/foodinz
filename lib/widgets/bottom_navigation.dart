import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          _NavigationBarItem(
              label: "messaging", iconData: Icons.message_rounded),
          _NavigationBarItem(
              label: "notifications", iconData: Icons.notifications),
        ],
      ),
    );
  }
}

class _NavigationBarItem extends StatelessWidget {
  const _NavigationBarItem(
      {Key? key, required this.label, required this.iconData})
      : super(key: key);
  final String label;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(iconData),
        Text(label),
      ],
    );
  }
}
