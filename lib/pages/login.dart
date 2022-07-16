import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodinz/global.dart';
import 'package:foodinz/main.dart';
import 'package:foodinz/pages/home.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'package:lottie/lottie.dart';

import '../widgets/home_screen.dart';
import '../widgets/opacity_tween.dart';
import '../widgets/slide_up_tween.dart';

enum OTP { notSent, sent, none }

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var locationMessage;
  bool showResend = false;
  String location = "";
  double lat = 0.0, lng = 0.0;
  File? avatar;
  Future<void> pickAvatar() async {
    final picker = ImagePicker();
    XFile? img = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (img != null) {
      avatar = File(img.path);
    }

    setState(() {});
  }

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

  final _otpFormKey = GlobalKey<FormState>();
  String v1 = "", v2 = "", v3 = "", v4 = "", v5 = "", v6 = "";

  OTP _formState = OTP.notSent;
  late PhoneAuthCredential credential;
  int seconds = 60;

  String verificationCode = "", phoneNumber = "";
  final TextEditingController _phoneController = TextEditingController();

  bool hideResend = false;

  Future<void> verifyPhoneNumber() async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 70),
      codeAutoRetrievalTimeout: (String verificationId) {
        Future.delayed(Duration.zero, () {
          setState(
            () {
              verificationCode = verificationId;
            },
          );
        });
      },
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!
        // Sign the user in (or link) with the auto-generated credential
        await auth.signInWithCredential(credential).then((value) async {
          debugPrint("done logging in");
        }).catchError((onError) {
          debugPrint("error saving user: ${onError.toString()}");
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          debugPrint('The provided phone number is not valid. ${phoneNumber}');
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
      const Duration(seconds: 40).inMilliseconds;

  late CountdownTimerController countdownTimerController;
  bool uploading = false;
  late final AnimationController _animationController;
  late Animation<double> _revealAnimation;
  TextEditingController _nameController = TextEditingController();
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _revealAnimation = CurvedAnimation(
        parent: _animationController, curve: Curves.fastLinearToSlowEaseIn);

    countdownTimerController = CountdownTimerController(
        endTime: endTime,
        onEnd: () {
          debugPrint("timer ended");
        });
    getLocation();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    countdownTimerController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  String region = "";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _animationController.reverse();
    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          Container(
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
                            begin: const Offset(10, 70),
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
                                      SizedBox(
                                        height: 80,
                                        child: Form(
                                          key: _formKey,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(
                                                  height: 68,
                                                  width: 45,
                                                  child: TextFormField(
                                                    onSaved: ((newValue) {}),
                                                    onChanged: (val) {
                                                      if (val.length == 1) {
                                                        v1 = val;
                                                        FocusScope.of(context)
                                                            .nextFocus();
                                                      }
                                                    },
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          1),
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 68,
                                                  width: 45,
                                                  child: TextFormField(
                                                    onSaved: ((newValue) {}),
                                                    onChanged: (val) {
                                                      if (val.length == 1) {
                                                        v2 = val;
                                                        FocusScope.of(context)
                                                            .nextFocus();
                                                      }
                                                    },
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          1),
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 68,
                                                  width: 45,
                                                  child: TextFormField(
                                                    onSaved: ((newValue) {}),
                                                    onChanged: (val) {
                                                      if (val.length == 1) {
                                                        v3 = val;
                                                        FocusScope.of(context)
                                                            .nextFocus();
                                                      }
                                                    },
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          1),
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 68,
                                                  width: 45,
                                                  child: TextFormField(
                                                    onSaved: ((newValue) {}),
                                                    onChanged: (val) {
                                                      if (val.length == 1) {
                                                        v4 = val;
                                                        FocusScope.of(context)
                                                            .nextFocus();
                                                      }
                                                    },
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          1),
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 68,
                                                  width: 45,
                                                  child: TextFormField(
                                                    onSaved: ((newValue) {}),
                                                    onChanged: (val) {
                                                      if (val.length == 1) {
                                                        v5 = val;
                                                        FocusScope.of(context)
                                                            .nextFocus();
                                                      }
                                                    },
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          1),
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 68,
                                                  width: 45,
                                                  child: TextFormField(
                                                    onSaved: ((newValue) {}),
                                                    onChanged: (val) {
                                                      if (val.length == 1) {
                                                        v6 = val;

                                                        FocusScope.of(context)
                                                            .nextFocus();
                                                      }
                                                    },
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                    decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: [
                                                      LengthLimitingTextInputFormatter(
                                                          1),
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              ]),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextButton(
                                          child: const Text(
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
                                              color: Colors.white
                                                  .withOpacity(.6))),
                                    ),
                                  const Spacer(flex: 3),
                                  CupertinoButton.filled(
                                    child: const Text("Verify Number"),
                                    onPressed: () async {
                                      debugPrint("done working");
                                      // await getLocation();
                                      debugPrint("complete verification");
                                      if (avatar != null) {
                                        await auth
                                            .signInWithCredential(
                                          PhoneAuthProvider.credential(
                                            verificationId: verificationCode,
                                            smsCode: "$v1$v2$v3$v4$v5$v6",
                                          ),
                                        )
                                            .then(
                                          (value) async {
                                            await _animationController
                                                .forward();

                                            String? deviceId = await getToken();
                                            String imageURL = '';
                                            if (avatar != null) {
                                              debugPrint("Image exists");
                                              FirebaseStorage storage =
                                                  FirebaseStorage.instance;
                                              Reference ref = storage
                                                  .ref()
                                                  .child("uploads/" +
                                                      DateTime.now()
                                                          .toString());
                                              UploadTask uploadTask = ref
                                                  .putFile(File(avatar!.path));
                                              final res = await uploadTask;
                                              res.ref
                                                  .getDownloadURL()
                                                  .then((value) async {
                                                debugPrint("Photo: $value");
                                                imageURL = value;

                                                await firestore
                                                    .collection("users")
                                                    .doc(auth.currentUser!.uid)
                                                    .set({
                                                  "address": "",
                                                  "email": "",
                                                  "name": _nameController.text
                                                      .trim(),
                                                  "phone": phoneNumber.trim(),
                                                  "image": value,
                                                  "lat": lat,
                                                  "long": lng,
                                                  "deviceId": deviceId,
                                                  "created_at": FieldValue
                                                      .serverTimestamp(),
                                                }).then((value) async {
                                                  sendNotif(
                                                    title:
                                                        "Well Done ${_nameController.text.trim()}",
                                                    description:
                                                        "You can start exploring Foodin. make sure to upload your profile photo",
                                                  );

                                                  debugPrint(
                                                      "done adding user to firebase");

                                                  Navigator.pushReplacement(
                                                    context,
                                                    PageRouteBuilder(
                                                      transitionDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  650),
                                                      reverseTransitionDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  650),
                                                      pageBuilder: ((context,
                                                          animation,
                                                          secondaryAnimation) {
                                                        return FadeTransition(
                                                            opacity: animation,
                                                            child:
                                                                const Home());
                                                      }),
                                                    ),
                                                  );
                                                }).catchError((error) {
                                                  debugPrint(error.toString());
                                                });
                                              }).catchError((onError) {
                                                debugPrint("$onError");
                                              });
                                            }
                                            debugPrint(
                                                "user is done verifying number.");
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setBool("loggedIn", true);
                                          },
                                        ).catchError(
                                          (onError) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              backgroundColor: Colors.pink,
                                              content: Text(
                                                  "Wrong Code, please try again.",
                                                  style: TextStyle(
                                                      color: Colors.white)),
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
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                elevation: 10,
                                                content: const Card(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                        "Forgot to add profile pic"),
                                                  ),
                                                )));
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 20),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    OpacityTween(
                                      duration:
                                          const Duration(milliseconds: 1300),
                                      child: SlideUpTween(
                                        duration:
                                            const Duration(milliseconds: 1300),
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
                                        SizedBox(
                                            width: size.width,
                                            height: 160,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                if (avatar == null)
                                                  Lottie.asset(
                                                      "assets/upload-photo.json",
                                                      width: 150,
                                                      height: 150,
                                                      reverse: true,
                                                      options: LottieOptions(
                                                          enableMergePaths:
                                                              true),
                                                      alignment:
                                                          Alignment.center,
                                                      fit: BoxFit.contain,
                                                      animate: true),
                                                if (avatar != null)
                                                  AnimatedOpacity(
                                                    duration: const Duration(
                                                        milliseconds: 450),
                                                    opacity: avatar == null
                                                        ? .1
                                                        : 1.0,
                                                    child: ClipOval(
                                                      child: Container(
                                                        width: 100,
                                                        height: 100,
                                                        color: Colors.white,
                                                        child: Center(
                                                          child: ClipOval(
                                                            child: Image.file(
                                                              avatar!,
                                                              fit: BoxFit.cover,
                                                              filterQuality:
                                                                  FilterQuality
                                                                      .high,
                                                              width: 90,
                                                              height: 90,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 100.0),
                                                    child: IconButton(
                                                        onPressed: () async {
                                                          await pickAvatar();
                                                        },
                                                        icon: const Icon(
                                                            Icons.person_add,
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                )
                                              ],
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0, vertical: 8),
                                          child: TextFormField(
                                            controller: _nameController,
                                            validator: (val) {
                                              return val == null || val.isEmpty
                                                  ? "Enter valid name"
                                                  : null;
                                            },
                                            style: const TextStyle(
                                                color: Colors.white),
                                            decoration: InputDecoration(
                                              hintStyle: const TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 226, 226, 226)),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                      color: Colors.white,
                                                      width: 1,
                                                      style:
                                                          BorderStyle.solid)),
                                              label: const Text(
                                                "Name",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              hintText: "Enter valid name",
                                              prefixIcon:
                                                  const Icon(Icons.person),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        if (_formState == OTP.notSent)
                                          OpacityTween(
                                            child: SlideUpTween(
                                              begin: const Offset(120, 0),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0,
                                                        vertical: 8),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Material(
                                                    elevation: 15,
                                                    color: Colors.grey[100],
                                                    shadowColor: Colors.grey
                                                        .withOpacity(.3),
                                                    child: IntlPhoneField(
                                                      controller:
                                                          _phoneController,
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText:
                                                            'Phone Number',
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                      initialCountryCode: 'CM',
                                                      onChanged: (phone) {
                                                        phoneNumber = phone
                                                            .completeNumber;
                                                        print(phone
                                                            .completeNumber);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (_formState == OTP.sent)
                                          TweenAnimationBuilder(
                                            curve:
                                                Curves.fastLinearToSlowEaseIn,
                                            tween: Tween<double>(
                                                begin: 0.0, end: 1.0),
                                            duration: const Duration(
                                                milliseconds: 600),
                                            builder: (_, double value, child) {
                                              return Opacity(
                                                  opacity: value, child: child);
                                            },
                                            child: const OpacityTween(
                                              child: const SlideUpTween(
                                                begin: Offset(100, 10),
                                                child: Text(
                                                    "change number if it fails"),
                                                // child: Container(
                                                //   margin:
                                                //       const EdgeInsets.symmetric(
                                                //           horizontal: 40),
                                                //   decoration: BoxDecoration(
                                                //     color: Colors.white,
                                                //     boxShadow: [
                                                //       BoxShadow(
                                                //         blurRadius: 10,
                                                //         color: Colors.grey
                                                //             .withOpacity(.5),
                                                //         offset: Offset(
                                                //           5,
                                                //           15,
                                                //         ),
                                                //       ),
                                                //     ],
                                                //   ),
                                                //   child: ,
                                                // ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 38.0),
                                      child: CupertinoButton.filled(
                                        child: const Text("Sign Up",
                                            style:
                                                TextStyle(color: Colors.black)),
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
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
          if (uploading)
            Align(
              alignment: Alignment.center,
              child: AnimatedBuilder(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        100 * (1 - _animationController.value),
                      ),
                    ),
                    child: Lottie.asset(
                      "assets/loading-animation.json",
                      width: size.width,
                      height: size.height,
                      repeat: true,
                      reverse: true,
                      options: LottieOptions(
                        enableMergePaths: true,
                      ),
                    ),
                    width: size.width * _animationController.value,
                    height: size.height * _animationController.value,
                  ),
                  animation: _animationController,
                  builder: (_, child) {
                    return Opacity(
                      opacity: _animationController.value,
                      child: Transform.scale(
                        scale: _animationController.value,
                        child: child,
                      ),
                    );
                  }),
            )
        ],
      ),
    );
  }
}
