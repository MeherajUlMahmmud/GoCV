import 'package:flutter/material.dart';
import 'package:gocv/providers/contact_data_provider.dart';
import 'package:gocv/providers/current_resume_provider.dart';
import 'package:gocv/providers/experience_list_provider.dart';
import 'package:gocv/providers/personal_data_provider.dart';
import 'package:gocv/providers/resume_list_provider.dart';
import 'package:gocv/providers/user_data_provider.dart';
import 'package:gocv/providers/user_profile_provider.dart';
import 'package:gocv/screens/utility_screens/splash_screen.dart';
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
