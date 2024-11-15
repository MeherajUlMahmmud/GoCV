import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gocv/providers/settings_provider.dart';
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
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
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
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: createLightTheme(),
      darkTheme: createDarkTheme(),
      themeMode: settingsProvider.themeMode,
      locale: Locale(settingsProvider.language),
      // Use the current language
      supportedLocales: const [
        Locale('en'), // English
        Locale('bn'), // Bengali
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateRoute: generateRoute,
      home: const SplashScreen(),
    );
  }
}
