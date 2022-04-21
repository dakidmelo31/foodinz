import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:foodinz/main.dart';
import 'package:foodinz/widgets/scale_tween.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'package:lottie/lottie.dart';

import '../themes/light_theme.dart';
import '../widgets/home_screen.dart';
import '../widgets/opacity_tween.dart';
import '../widgets/slide_up_tween.dart';
import 'home.dart';

enum OTP { notSent, sent, none }

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

FirebaseAuth auth = FirebaseAuth.instance;

FirebaseFirestore firestore = FirebaseFirestore.instance;

class _LoginState extends State<Login> {
  var locationMessage;
  bool showResend = false;
  String location = "";
  double lat = 0.0, lng = 0.0;

  Future<void> getLocation() async {
    var locationStatus = await Permission.location.status;
    if (locationStatus.isGranted) {
      debugPrint("is granted");
    } else {
      if (locationStatus.isDenied) {
        debugPrint("Not granted");
        Map<Permission, PermissionStatus> status =
            await [Permission.location].request();
      } else {
        if (locationStatus.isPermanentlyDenied) {
          openAppSettings().then((value) {});
        }
      }
    }

    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    debugPrint("move the next step. again");
    debugPrint(position.toString());
    var lastPosition = await Geolocator.getLastKnownPosition();
    print("position is $lastPosition");

    lat = position.latitude;
    lng = position.longitude;
    debugPrint("latitude: $lat, and logitude: $lng");
  }

  OTP _formState = OTP.notSent;
  late PhoneAuthCredential credential;
  int seconds = 60;

  String verificationCode = "", phoneNumber = "";
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  bool hideResend = false;

  Future<void> verifyPhoneNumber() async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 70),
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(
          () {
            verificationCode = verificationId;
          },
        );
      },
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!
        // Sign the user in (or link) with the auto-generated credential
        await auth.signInWithCredential(credential).then((value) async {
          debugPrint("done logging in");
        }).catchError((onError) =>
            {debugPrint("error saving user: ${onError.toString()}")});
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid. ${phoneNumber}');
        } else {
          debugPrint("there is another error: ${e.message}");
        }

        // Handle other errors
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        setState(() {
          verificationCode = verificationId;
        });
      },
    );
  }

  int endTime = DateTime.now().millisecondsSinceEpoch +
      Duration(seconds: 40).inMilliseconds;

  late CountdownTimerController countdownTimerController;

  @override
  void initState() {
    countdownTimerController = CountdownTimerController(
        endTime: endTime,
        onEnd: () {
          debugPrint("timer ended");
        });
    super.initState();
  }

  bool _showPassword = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String region = "";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: const AssetImage("assets/bg7.jpg"),
              colorFilter: const ColorFilter.linearToSrgbGamma(),
              alignment: Alignment.center,
              fit: BoxFit.cover,
              onError: (trace, hold) {
                Lottie.asset("assets/loading2.json");
              }),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(.8),
                Colors.black.withOpacity(.51),
                Colors.deepOrange.withOpacity(.8),
                Colors.orange
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              width: size.width,
              height: size.height,
              child: ListView(
                children: [
                  if (_formState == OTP.sent)
                    OpacityTween(
                      child: SlideUpTween(
                        begin: Offset(10, 70),
                        child: Container(
                          width: size.width,
                          height: size.height - kToolbarHeight,
                          child: Column(
                            children: [
                              const Spacer(flex: 1),
                              Lottie.asset("assets/loading5.json",
                                  width: size.width * .4,
                                  height: size.width * .4),
                              const Spacer(flex: 2),
                              Column(
                                children: [
                                  TextField(
                                    controller: _otpController,
                                    maxLength: 6,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2),
                                      ),
                                      labelStyle: TextStyle(
                                        fontSize: 20,
                                      ),
                                      label: Text(
                                        "OTP Verification",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      hintText: "Enter Verification code",
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  TextButton(
                                      child: Text(
                                        "Change number",
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _formState = OTP.notSent;
                                        });
                                      }),
                                ],
                              ),
                              if (showResend)
                                CupertinoButton(
                                  onPressed: () {
                                    setState(() {
                                      _formState = OTP.notSent;
                                    });
                                  },
                                  child: Text("Change Number",
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(.6))),
                                ),
                              const Spacer(flex: 3),
                              CupertinoButton.filled(
                                child: const Text("Verify Number"),
                                onPressed: () async {
                                  debugPrint("done working");
                                  // await getLocation();
                                  debugPrint("complete verification");
                                  await auth
                                      .signInWithCredential(
                                    PhoneAuthProvider.credential(
                                      verificationId: verificationCode,
                                      smsCode: _otpController.text.trim(),
                                    ),
                                  )
                                      .then(
                                    (value) async {
                                      firestore
                                          .collection("users")
                                          .doc(auth.currentUser!.uid)
                                          .set({
                                        "name": _nameController.text.trim(),
                                        "phone": phoneNumber.trim(),
                                        "image": "",
                                        "lat": lat,
                                        "long": lng,
                                        "created_at":
                                            FieldValue.serverTimestamp(),
                                      }).then((value) {
                                        debugPrint(
                                            "done adding user to firebase");
                                        Navigator.pushReplacement(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration:
                                                Duration(milliseconds: 650),
                                            reverseTransitionDuration:
                                                Duration(milliseconds: 650),
                                            pageBuilder: ((context, animation,
                                                secondaryAnimation) {
                                              return FadeTransition(
                                                  opacity: animation,
                                                  child: const HomeScreen());
                                            }),
                                          ),
                                        );
                                      }).catchError((error) {
                                        debugPrint(error.toString());
                                      });
                                      debugPrint(
                                          "user is done verifying number.");
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setBool("loggedIn", true);
                                    },
                                  ).catchError(
                                    (onError) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        backgroundColor: Colors.pink,
                                        content: Text(
                                            "Wrong Code, please try again.",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        duration: Duration(seconds: 5),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 15),
                                      ));
                                      setState(() {
                                        showResend = true;
                                      });
                                      debugPrint(
                                        onError.toString(),
                                      );
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (_formState == OTP.notSent)
                    Container(
                      child: Form(
                        key: _formKey,
                        child: Container(
                          width: size.width,
                          height: size.height,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                OpacityTween(
                                  duration: Duration(milliseconds: 1300),
                                  child: SlideUpTween(
                                    duration: Duration(milliseconds: 1300),
                                    begin: const Offset(10, 70),
                                    child: SizedBox(
                                      height: size.height * .31,
                                      child: Center(
                                        child: Text("Sign, It's Free",
                                            style: headingStyles),
                                      ),
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: _nameController,
                                      validator: (val) {
                                        return val == null || val.isEmpty
                                            ? "Enter valid Information"
                                            : null;
                                      },
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        label: Text(
                                          "Name",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        hintText: "Enter valid name",
                                        prefixIcon: Icon(Icons.person),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    if (_formState == OTP.notSent)
                                      OpacityTween(
                                        child: SlideUpTween(
                                          begin: Offset(120, 0),
                                          child: Material(
                                            elevation: 15,
                                            color: Colors.grey[100],
                                            shadowColor:
                                                Colors.grey.withOpacity(.3),
                                            child: IntlPhoneField(
                                              controller: _phoneController,
                                              style: TextStyle(
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                labelText: 'Phone Number',
                                                border: InputBorder.none,
                                              ),
                                              initialCountryCode: 'CM',
                                              onChanged: (phone) {
                                                phoneNumber =
                                                    phone.completeNumber;
                                                print(phone.completeNumber);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (_formState == OTP.sent)
                                      TweenAnimationBuilder(
                                        curve: Curves.fastLinearToSlowEaseIn,
                                        tween:
                                            Tween<double>(begin: 0.0, end: 1.0),
                                        duration: Duration(milliseconds: 600),
                                        builder: (_, double value, child) {
                                          return Opacity(
                                              opacity: value, child: child);
                                        },
                                        child: OpacityTween(
                                          child: SlideUpTween(
                                            begin: Offset(100, 10),
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 40),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 10,
                                                    color: Colors.grey
                                                        .withOpacity(.5),
                                                    offset: Offset(
                                                      5,
                                                      15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              child: TextField(
                                                keyboardType:
                                                    TextInputType.phone,
                                                controller: _otpController,
                                                decoration: InputDecoration(
                                                  hintText: "Enter Code ",
                                                  label: Text(
                                                    "OTP Code",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    SizedBox(
                                        height: 45,
                                        child: Center(
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                _showPassword = !_showPassword;
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Show password",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                CupertinoSwitch(
                                                    trackColor: Colors.grey,
                                                    value: _showPassword,
                                                    activeColor: Colors.orange,
                                                    onChanged: (onChanged) {
                                                      setState(() {
                                                        _showPassword =
                                                            onChanged;
                                                      });
                                                    }),
                                              ],
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 38.0),
                                  child: CupertinoButton.filled(
                                    child: const Text("Sign Up",
                                        style: TextStyle(color: Colors.black)),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        debugPrint("call signup function");
                                        setState(() {
                                          verifyPhoneNumber();
                                          _formState = OTP.sent;
                                        });
                                      }
                                    },
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * .25,
                                        vertical: 10),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
