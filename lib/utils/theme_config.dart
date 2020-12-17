import 'package:flutter/material.dart';

class ThemeConfig {
  static Color lightPrimary = Colors.white;
  static Color darkPrimary = Colors.black54;
  static Color lightAccent = Colors.blueAccent;
  static Color darkAccent = Colors.blue;
  static Color lightBG = Colors.white;
  static Color darkBG = Colors.black;

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    backgroundColor: lightBG,
    primarySwatch: Colors.blue,
    primaryColor: Colors.white,
    accentColor: Colors.blueAccent,
    iconTheme: IconThemeData(color: Colors.blue),
    cursorColor: Colors.blueAccent,
    scaffoldBackgroundColor: lightBG,
    dividerColor: Colors.white54,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primarySwatch: Colors.blue,
    primaryColor: Colors.black,
    accentColor: Colors.blueAccent,
    cursorColor: Colors.blueAccent,
    tabBarTheme: TabBarTheme(
      labelColor: Colors.white,
      labelStyle: TextStyle(color: Colors.white),
      unselectedLabelColor: Colors.grey,
      unselectedLabelStyle: TextStyle(color: Colors.grey),
    ),
    scaffoldBackgroundColor: darkBG,
    dividerColor: Colors.black54,
  );

//  final darkTheme = ThemeData(
//    primarySwatch: Colors.grey,
//    primaryColor: Colors.black,
//    brightness: Brightness.dark,
//    backgroundColor: const Color(0xFF212121),
//    accentColor: Colors.white,
//    accentIconTheme: IconThemeData(color: Colors.black),
//    dividerColor: Colors.black12,
//  );
//
//  final lightTheme = ThemeData(
//    primarySwatch: Colors.grey,
//    primaryColor: Colors.white,
//    brightness: Brightness.light,
//    backgroundColor: const Color(0xFFE5E5E5),
//    accentColor: Colors.black,
//    accentIconTheme: IconThemeData(color: Colors.blue),
//    dividerColor: Colors.white54,
//  );
}
