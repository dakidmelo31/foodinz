import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoxIndicatorPainter extends BoxPainter {
  BoxIndicatorPainter();
  static const radius = 8.0;
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final dx = configuration.size!.width / 2;
    final dy = configuration.size!.height + radius / 2;
    final c = offset + Offset(dx, dy);
    final paint = Paint()..color = Colors.orange;
    canvas.drawCircle(c, radius, paint);
  }
}

class DotIndicator extends Decoration {
  DotIndicator();
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return BoxIndicatorPainter();
  }
}
