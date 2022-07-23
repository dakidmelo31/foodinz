import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class ConnectivityWidget extends StatefulWidget {
  const ConnectivityWidget({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  State<ConnectivityWidget> createState() => _ConnectivityWidgetState();
}

class _ConnectivityWidgetState extends State<ConnectivityWidget>
    with TickerProviderStateMixin {
  late Stream<ConnectivityResult> _connectivityStream;
  late AnimationController _onlineController;
  @override
  void initState() {
    _connectivityStream = Connectivity().onConnectivityChanged;
    _onlineController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 600,
      ),
    );

    _onlineController.addListener(() {
      debugPrint(_onlineController.value.toString());
      if (_onlineController.isCompleted) {
        debugPrint("completed animation");
        Future.delayed(Duration(seconds: 5), () {
          _onlineController.reverse();
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _onlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        widget.child,
        StreamBuilder<ConnectivityResult>(
            stream: _connectivityStream,
            builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox.shrink();
              }
              if (snapshot.requireData == ConnectivityResult.mobile) {
                double value = 20.0;
                _onlineController.forward();
                return AnimatedBuilder(
                    animation: _onlineController,
                    builder: (context, child) {
                      Animation<double> animation = CurvedAnimation(
                          parent: _onlineController,
                          curve: Curves.fastLinearToSlowEaseIn);
                      return Align(
                        alignment: Alignment.topCenter,
                        child: Material(
                          color: Colors.transparent,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.fastLinearToSlowEaseIn,
                            color: Colors.green,
                            child: Center(
                                child: Text(
                              "Online",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            )),
                            height: value * animation.value,
                            width: size.width,
                          ),
                        ),
                      );
                    });
              }

              if (snapshot.requireData == ConnectivityResult.wifi) {
                double value = 20.0;
                _onlineController.forward();
                return AnimatedBuilder(
                    animation: _onlineController,
                    builder: (context, child) {
                      Animation<double> animation = CurvedAnimation(
                          parent: _onlineController,
                          curve: Curves.fastLinearToSlowEaseIn);
                      return Align(
                        alignment: Alignment.topCenter,
                        child: Material(
                          color: Colors.transparent,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.fastLinearToSlowEaseIn,
                            color: Colors.blue,
                            child: Center(
                                child: Text(
                              "Using Wifi",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            )),
                            height: value * animation.value,
                            width: size.width,
                          ),
                        ),
                      );
                    });
              }

              if (snapshot.requireData == ConnectivityResult.none) {
                double value = 20.0;
                return AnimatedBuilder(
                    animation: _onlineController,
                    builder: (context, child) {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: Material(
                          color: Colors.transparent,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.fastLinearToSlowEaseIn,
                            color: Colors.pink,
                            child: Center(
                                child: Text(
                              "Offline",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            )),
                            height: value,
                            width: size.width,
                          ),
                        ),
                      );
                    });
              }

              return SizedBox.shrink();
            })
      ],
    );
  }
}
