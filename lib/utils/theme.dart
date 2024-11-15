import 'package:flutter/material.dart';

import 'colors.dart';

ThemeData createLightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    useMaterial3: false,
    primarySwatch: createMaterialColor(const Color(0xFF532AD6)),
    primaryColor: createMaterialColor(const Color(0xFF532AD6)),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Color(0xFF532AD6),
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(fontSize: 18.0),
    ),
    scaffoldBackgroundColor: Colors.white,
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: Colors.grey,
      suffixIconColor: createMaterialColor(const Color(0xFF532AD6)),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: createMaterialColor(const Color(0xFF532AD6)),
          width: 2.0,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: createMaterialColor(const Color(0xFF100720)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: createMaterialColor(const Color(0xFF532AD6)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}

ThemeData createDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    useMaterial3: false,
    primarySwatch: createMaterialColor(const Color(0xFF532AD6)),
    primaryColor: createMaterialColor(const Color(0xFF532AD6)),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(fontSize: 18.0),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: Colors.grey[400],
      suffixIconColor: createMaterialColor(const Color(0xFF532AD6)),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: createMaterialColor(const Color(0xFF532AD6)),
          width: 2.0,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: createMaterialColor(const Color(0xFF532AD6)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}
