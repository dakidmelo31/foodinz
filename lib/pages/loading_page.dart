import 'package:flutter/material.dart';
import 'package:foodinz/pages/data_backup_init_page.dart';
import 'package:foodinz/pages/data_backup_storage.dart';
import 'package:foodinz/pages/storage_completed.dart';

const mainDataBackupColor = Color(0xFF5113AA);
const secondaryDataBackupColor = Color(0xFFBC53FA);
const backgroundColor = Color(0xFFfce7fe);

class DataBackupHome extends StatefulWidget {
  const DataBackupHome({Key? key}) : super(key: key);

  @override
  State<DataBackupHome> createState() => _DataBackupHomeState();
}

class _DataBackupHomeState extends State<DataBackupHome>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _storageAnimation;
  late Animation<double> _endingAnimation;
  late Animation<double> _bubbleAnimation;
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    _progressAnimation = CurvedAnimation(
        parent: _animationController, curve: Interval(0.0, 0.65));
    _storageAnimation = CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.7, 0.85, curve: Curves.easeOut));
    _endingAnimation = CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.8, 1.0, curve: Curves.decelerate));
    super.initState();
    _bubbleAnimation = CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 1.0, curve: Curves.decelerate));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            DataBackupInitPage(
              progressAnimation: _progressAnimation,
              onAnimationStarted: () {
                _animationController.forward();
              },
            ),
            DataStorage(
                progressAnimation: _progressAnimation,
                storageAnimation: _storageAnimation,
                bubbleAnimation: _bubbleAnimation),
            StorageCompleted(
              endingAnimation: _endingAnimation,
            )
          ],
        ));
  }
}
