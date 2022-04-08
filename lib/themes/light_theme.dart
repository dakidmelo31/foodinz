import 'package:flutter/material.dart';

class Primary {
  static const Color backgroundColor = Colors.white;
  static const Color accentColor = Colors.orange;
  static const Color primaryColor = Colors.deepOrange;
  static const TextStyle paragraph = TextStyle(
    color: Colors.black,
  );
  static const TextStyle bigHeading = TextStyle(
    color: Colors.black,
    fontSize: 20,
  );
  static const TextStyle lightParagraph = TextStyle(
    color: Colors.black54,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle heading = TextStyle(
      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0);
  static const TextStyle shawarmaHeading = TextStyle(
      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0);
  static ThemeData primaryTheme = ThemeData(
      primarySwatch: Colors.orange,
      backgroundColor: Colors.white,
      accentColor: Colors.black,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.white,
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        contentTextStyle: TextStyle(color: Colors.black),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white,
        elevation: 10,
        modalBackgroundColor: Colors.black.withOpacity(.6),
        modalElevation: 15,
      ),
      errorColor: Colors.black,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        elevation: 10,
        enableFeedback: true,
      ));
}
