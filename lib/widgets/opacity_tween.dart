import 'package:flutter/material.dart';

class OpacityTween extends StatelessWidget {
  const OpacityTween({
    Key? key,
    this.begin = 0.2,
    required this.child,
    this.curve = Curves.easeInToLinear,
    this.duration = const Duration(milliseconds: 700),
  }) : super(key: key);
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double begin;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: begin, end: 1.0),
        duration: duration,
        child: child,
        builder: (_, value, child) {
          return Opacity(
            opacity: value,
            child: child,
          );
        });
  }
}
