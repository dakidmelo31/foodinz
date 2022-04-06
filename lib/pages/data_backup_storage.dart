import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:foodinz/pages/loading_page.dart';

class _Bubble {
  _Bubble({
    required this.color,
    required this.direction,
    required this.speed,
    required this.size,
    required this.initialPosition,
  });

  final Color color;
  final double direction;
  final double speed;
  final double size;
  final double initialPosition;
}

class DataStorage extends StatelessWidget {
  DataStorage(
      {Key? key,
      required this.storageAnimation,
      required this.bubbleAnimation,
      required this.progressAnimation})
      : super(key: key);
  final Animation<double> storageAnimation, progressAnimation, bubbleAnimation;
  final bubbles = List<_Bubble>.generate(500, (index) {
    final size = math.Random().nextInt(20) + 5.0;
    final speed = math.Random().nextInt(50) + 1.0;
    final randomDirection = math.Random().nextBool();
    final randomColor = math.Random().nextBool();
    final direction =
        math.Random().nextInt(250) * (randomDirection ? 1.0 : -1.0);
    final color = randomColor ? mainDataBackupColor : secondaryDataBackupColor;
    return _Bubble(
      color: color,
      direction: direction,
      initialPosition: index * 10.0,
      size: size,
      speed: speed,
    );
  });

  @override
  Widget build(BuildContext context) {
    Size queryData = MediaQuery.of(context).size;

    return AnimatedBuilder(
        animation: Listenable.merge([progressAnimation, storageAnimation]),
        builder: (context, snapshot) {
          final size = queryData.width * .5;
          final circleSize = size *
              math.pow(
                  (progressAnimation.value + storageAnimation.value + 1), 2);
          final topPosition = queryData.height * .45;
          final centerMargin = queryData.width - circleSize;
          final leftSize = size * .6 * (1 - progressAnimation.value);
          final rightSize = size * .7 * (1 - progressAnimation.value);

          final leftMargin = queryData.width / 2 - leftSize * 1.2;
          final rightMargin = queryData.width / 2 - rightSize * 1.2;
          final middleMargin =
              queryData.width / 2 - (size / 2) * (1 - progressAnimation.value);
          final topOutPosition = queryData.height * storageAnimation.value;

          return Positioned(
              left: 0,
              right: 0,
              top: topPosition - circleSize + topOutPosition,
              height: circleSize,
              child: Stack(
                children: [
                  Positioned(
                    width: size * (1 - progressAnimation.value),
                    height: leftSize / 2,
                    left: middleMargin,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    width: leftSize,
                    height: leftSize,
                    left: leftMargin,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    width: leftSize,
                    height: rightSize,
                    left: leftMargin,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    width: leftSize,
                    height: rightSize,
                    right: rightMargin / 2,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    height: circleSize,
                    width: circleSize,
                    bottom: 0,
                    left: centerMargin / 2,
                    child: ClipOval(
                      child: CustomPaint(
                        foregroundPainter: _DataStoragePainter(
                          animation: bubbleAnimation,
                          bubbles: bubbles,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ));
        });
  }
}

class _DataStoragePainter extends CustomPainter {
  _DataStoragePainter({required this.animation, required this.bubbles})
      : super(repaint: animation);
  final Animation<double> animation;
  final List<_Bubble> bubbles;
  @override
  void paint(Canvas canvas, Size size) {
    for (_Bubble bubble in bubbles) {
      final offset = Offset(
          size.width / 2 + bubble.direction * animation.value,
          size.height * (1 - animation.value) -
              bubble.speed * animation.value +
              bubble.initialPosition * (1 - animation.value));
      canvas.drawCircle(offset, bubble.size, Paint()..color = bubble.color);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
