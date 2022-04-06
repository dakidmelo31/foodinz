import 'package:flutter/material.dart';
import 'package:foodinz/pages/loading_page.dart';

const _duration = Duration(milliseconds: 300);

class DataBackupInitPage extends StatefulWidget {
  const DataBackupInitPage(
      {Key? key,
      required this.progressAnimation,
      required this.onAnimationStarted})
      : super(key: key);
  final Animation<double> progressAnimation;
  final VoidCallback onAnimationStarted;

  @override
  State<DataBackupInitPage> createState() => _DataBackupInitPageState();
}

class _DataBackupInitPageState extends State<DataBackupInitPage> {
  DataInitstate _currentState = DataInitstate.init;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                "Create Meal",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            if (_currentState == DataInitstate.end)
              Expanded(
                flex: 2,
                child: TweenAnimationBuilder(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: _duration,
                  builder: (_, double value, child) {
                    return Opacity(opacity: value, child: child);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Creating Meal",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: ProgressCounter(widget.progressAnimation),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_currentState != DataInitstate.end)
              Expanded(
                flex: 2,
                child: TweenAnimationBuilder(
                  tween: Tween(
                      begin: 1.0,
                      end: _currentState != DataInitstate.init ? 0.0 : 1.0),
                  duration: _duration,
                  builder: (_, double value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                          offset: Offset(0.0, -50.0 * value), child: child),
                    );
                  },
                  onEnd: () {
                    setState(() {
                      _currentState = DataInitstate.end;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        "Last Meal created",
                      ),
                      Text(
                        "3 minutes ago",
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(
              width: size.width,
              child: AnimatedSwitcher(
                duration: _duration,
                child: _currentState == DataInitstate.init
                    ? RaisedButton(
                        onPressed: () {
                          setState(() {
                            _currentState = DataInitstate.start;
                            widget.onAnimationStarted();
                          });
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "Save and Publish",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        color: mainDataBackupColor)
                    : OutlineButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 40.0),
                          child: Text("Cancel",
                              style: TextStyle(color: mainDataBackupColor)),
                        )),
              ),
            ),
            const SizedBox(height: 25)
          ],
        ),
      ),
    );
  }
}

enum DataInitstate { init, start, end }

class ProgressCounter extends AnimatedWidget {
  ProgressCounter(Animation<double> animation) : super(listenable: animation);

  double get value => (listenable as Animation).value;

  @override
  Widget build(BuildContext context) {
    return Text((100 * value).truncate().toString() + "%");
  }
}
