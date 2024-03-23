import 'package:flutter/material.dart';
import 'package:gocv/screens/auth_screens/login_screen.dart';
import 'package:gocv/screens/auth_screens/sign_up_screen.dart';
import 'package:gocv/screens/home_screen.dart';
import 'package:gocv/screens/main_screens/resume_details/resume_details_screen.dart';
import 'package:gocv/screens/main_screens/resume_preview_screen.dart';
import 'package:gocv/screens/profile_screens/profile_screen.dart';
import 'package:gocv/screens/profile_screens/update_profile_screen.dart';
import 'package:gocv/screens/utility_screens/account_settings_screen.dart';
import 'package:gocv/screens/utility_screens/not_found_screen.dart';
import 'package:gocv/screens/utility_screens/settings_screen.dart';
import 'package:gocv/screens/utility_screens/splash_screen.dart';

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
