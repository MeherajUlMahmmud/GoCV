import 'package:flutter/material.dart';
import 'package:gocv/screens/auth_screens/LoginScreen.dart';
import 'package:gocv/screens/auth_screens/SignUpScreen.dart';
import 'package:gocv/screens/home_screen.dart';
import 'package:gocv/screens/main_screens/ResumeDetailsScreen.dart';
import 'package:gocv/screens/main_screens/ResumePreviewScreen.dart';
import 'package:gocv/screens/profile_screens/ProfileScreen.dart';
import 'package:gocv/screens/profile_screens/UpdateProfileScreen.dart';
import 'package:gocv/screens/utility_screens/AccountSettingsScreen.dart';
import 'package:gocv/screens/utility_screens/NotFoundScreen.dart';
import 'package:gocv/screens/utility_screens/SettingsScreen.dart';
import 'package:gocv/screens/utility_screens/SplashScreen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashScreen.routeName:
      return MaterialPageRoute(builder: (context) => const SplashScreen());
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case SignUpScreen.routeName:
      return MaterialPageRoute(builder: (context) => const SignUpScreen());
    case HomeScreen.routeName:
      return MaterialPageRoute(builder: (context) => const HomeScreen());
    case ResumeDetailsScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const ResumeDetailsScreen());
    case ResumePreviewScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const ResumePreviewScreen());
    case ProfileScreen.routeName:
      return MaterialPageRoute(builder: (context) => const ProfileScreen());
    case UpdateProfileScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const UpdateProfileScreen());
    case SettingsScreen.routeName:
      return MaterialPageRoute(builder: (context) => const SettingsScreen());
    case AccountSettingsScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const AccountSettingsScreen());
    default:
      return MaterialPageRoute(builder: (context) => const NotFoundScreen());
  }
}
