import 'package:flutter/material.dart';

class SlideUpTween extends StatelessWidget {
  const SlideUpTween(
      {Key? key,
      required this.begin,
      required this.child,
      this.curve = Curves.easeOut,
      this.duration = const Duration(milliseconds: 450)})
      : super(key: key);
  final Widget child;
  final Offset begin;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
        tween: Tween(begin: begin, end: const Offset(0, 0)),
        duration: duration,
        child: child,
        builder: (_, value, child) {
          return Transform.translate(offset: value, child: child);
        });
  }
}
