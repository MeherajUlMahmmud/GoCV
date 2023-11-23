import 'package:flutter/material.dart';
import 'package:gocv/utils/colors.dart';

ThemeData createTheme() {
  return ThemeData(
    useMaterial3: false,
    primarySwatch: createMaterialColor(const Color(0xB316BFC4)),
    primaryColor: createMaterialColor(const Color(0xB316BFC4)),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: Colors.grey,
      suffixIconColor: createMaterialColor(const Color(0xFF100720)),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: createMaterialColor(const Color(0xFF100720)),
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: createMaterialColor(const Color(0xFF100720)),
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      labelStyle: TextStyle(
        color: createMaterialColor(const Color(0xFF100720)),
      ),
      hintStyle: TextStyle(
        color: createMaterialColor(const Color(0xFF100720)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: createMaterialColor(const Color(0xFF100720)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: createMaterialColor(const Color(0xFF100720)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}
