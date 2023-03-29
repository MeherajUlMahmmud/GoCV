import 'package:cv_builder/screens/auth_screens/LoginScreen.dart';
import 'package:cv_builder/screens/home_screen.dart';
import 'package:cv_builder/screens/utility_screens/SettingsScreen.dart';
import 'package:cv_builder/screens/utility_screens/SplashScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      title: 'GoCV',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          elevation: 5,
          centerTitle: true,
        ),
      ),
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        Settingsscreen.routeName: (context) => Settingsscreen(),
      },
    );
  }
}
