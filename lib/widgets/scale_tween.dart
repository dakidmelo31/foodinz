import 'package:flutter/material.dart';

class ScaleTween extends StatelessWidget {
  const ScaleTween(
      {Key? key,
      this.begin = 2.0,
      required this.child,
      this.duration = const Duration(milliseconds: 750)})
      : super(key: key);
  final Duration duration;
  final Widget child;
  final double begin;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        tween: Tween(begin: begin, end: 1.0),
        duration: duration,
        builder: (_, double value, child) {
          return Transform.scale(
            scale: value,
            // scaleX: value,
            // scaleY: value,
            child: child,
          );
        });
  }
}
