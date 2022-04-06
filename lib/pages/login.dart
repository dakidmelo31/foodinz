import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodinz/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'package:lottie/lottie.dart';

import 'home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

FirebaseAuth auth = FirebaseAuth.instance;

FirebaseFirestore firestore = FirebaseFirestore.instance;

class _LoginState extends State<Login> {
  signup(
      {required String name,
      required String email,
      required String password,
      required BuildContext context}) async {
    firestore.collection("users").add({
      "name": name,
      "email": email,
      "password": password,
    }).then((value) {
      auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        debugPrint("Done Creating user");

        auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((val) {
          debugPrint("done relogging user in");
          Navigator.pushReplacementNamed(context, Home.routeName);
        });
      }).catchError((onError) {
        debugPrint("Error signing up: $onError");
      });
    });
  }

  login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      debugPrint("login user again");
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool("userLoggedIn", true);
      prefs.setString("email", email);

      prefs.setString("password", password).then((value) {
        value ? debugPrint("Login successful") : debugPrint("Loging failed");
      });
    });
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
    return Scaffold(
      body: Container(
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
        child: ListView(
          children: [
            Container(
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
              child: Form(
                key: _formKey,
                child: Container(
                  width: size.width,
                  height: size.height,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height * .31,
                          child: Center(
                            child: Text("Sign up Today", style: headingStyles),
                          ),
                          width: double.infinity,
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
                            TextFormField(
                              controller: _emailController,
                              validator: (val) {
                                return val == null || val.isEmpty
                                    ? "Enter valid Information"
                                    : null;
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                label: Text(
                                  "Email",
                                  style: TextStyle(color: Colors.white),
                                ),
                                hintText: "Enter valid email",
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              obscureText: _showPassword,
                              controller: _passwordController,
                              validator: (val) {
                                return val == null ||
                                        val.isEmpty ||
                                        val.length < 5
                                    ? "Password is too weak"
                                    : null;
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                label: Text(
                                  "Password",
                                  style: TextStyle(color: Colors.white),
                                ),
                                hintText: "Enter Strong password",
                                prefixIcon: Icon(Icons.person),
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
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        CupertinoSwitch(
                                            trackColor: Colors.grey,
                                            value: _showPassword,
                                            activeColor: Colors.orange,
                                            onChanged: (onChanged) {
                                              setState(() {
                                                _showPassword = onChanged;
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
                            child: Text("Sign Up"),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                debugPrint("call signup function");
                                signup(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    context: context);
                              }
                            },
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * .25, vertical: 10),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
