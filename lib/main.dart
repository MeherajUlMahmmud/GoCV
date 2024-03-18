import 'package:flutter/material.dart';
import 'package:gocv/providers/ContactDataProvider.dart';
import 'package:gocv/providers/CurrentResumeProvider.dart';
import 'package:gocv/providers/ExperienceListProvider.dart';
import 'package:gocv/providers/PersonalDataProvider.dart';
import 'package:gocv/providers/ResumeListProvider.dart';
import 'package:gocv/providers/UserDataProvider.dart';
import 'package:gocv/providers/UserProfileProvider.dart';
import 'package:gocv/screens/utility_screens/SplashScreen.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/routes_handler.dart';
import 'package:gocv/utils/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => UserProfileProvider()),
        ChangeNotifierProvider(create: (context) => ResumeListProvider()),
        ChangeNotifierProvider(create: (context) => CurrentResumeProvider()),
        ChangeNotifierProvider(create: (context) => PersonalDataProvider()),
        ChangeNotifierProvider(create: (context) => ContactDataProvider()),
        ChangeNotifierProvider(create: (context) => ExperienceListProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
