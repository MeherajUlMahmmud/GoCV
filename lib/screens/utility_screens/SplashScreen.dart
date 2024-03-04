import 'package:gocv/models/user.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/screens/auth_screens/LoginScreen.dart';
import 'package:gocv/screens/home_screen.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  LocalStorage localStorage = LocalStorage();

  void checkUser() async {
    final Map<String, dynamic> tokens = await localStorage.readData('tokens');

    if (!mounted) return;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (tokens['access'] == null || tokens['refresh'] == null) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      });
    } else {
      // Set tokens in the provider
      userProvider.setTokens(tokens);

      // Load user data from local storage
      final userDataJson = await localStorage.readData('user');

      UserBase userData = UserBase.fromJson(userDataJson);
      // Set user data in the provider
      userProvider.setUserData(userData);

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          Constants.appName,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
