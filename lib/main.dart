import 'package:gocv/screens/auth_screens/LoginScreen.dart';
import 'package:gocv/screens/auth_screens/SignUpScreen.dart';
import 'package:gocv/screens/home_screen.dart';
import 'package:gocv/screens/profile_screens/ProfileScreen.dart';
import 'package:gocv/screens/profile_screens/UpdateProfileScreen.dart';
import 'package:gocv/screens/utility_screens/AccountSettingsScreen.dart';
import 'package:gocv/screens/utility_screens/SettingsScreen.dart';
import 'package:gocv/screens/utility_screens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:gocv/utils/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoCV',
      theme: ThemeData(
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
      ),
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        SignUpScreen.routeName: (context) => const SignUpScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        UpdateProfileScreen.routeName: (context) => const UpdateProfileScreen(),
        SettingsScreen.routeName: (context) => const SettingsScreen(),
        AccountSettingsScreen.routeName: (context) =>
            const AccountSettingsScreen(),
      },
    );
  }
}
