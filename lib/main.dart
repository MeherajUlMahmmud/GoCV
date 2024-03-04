import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/screens/utility_screens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/routes_handler.dart';
import 'package:gocv/utils/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: createTheme(),
      onGenerateRoute: generateRoute,
      home: const SplashScreen(),
    );
  }
}
