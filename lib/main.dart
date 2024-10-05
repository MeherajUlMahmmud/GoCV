import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/contact_data_provider.dart';
import 'providers/current_resume_provider.dart';
import 'providers/experience_list_provider.dart';
import 'providers/personal_data_provider.dart';
import 'providers/resume_list_provider.dart';
import 'providers/user_data_provider.dart';
import 'providers/user_profile_provider.dart';
import 'screens/utility_screens/splash_screen.dart';
import 'utils/constants.dart';
import 'utils/routes_handler.dart';
import 'utils/theme.dart';

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
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

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
