import 'package:gocv/screens/utility_screens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:gocv/utils/routes_handler.dart';
import 'package:gocv/utils/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoCV',
      theme: createTheme(),
      onGenerateRoute: generateRoute,
      home: const SplashScreen(),
    );
  }
}
