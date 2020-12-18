import 'package:cv_builder/screens/homescreen.dart';
import 'package:cv_builder/utils/theme_config.dart';
import 'package:cv_builder/view_models/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// void main() {
//   runApp(MyApp());
// }

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
//          ChangeNotifierProvider(create: (_) => HomeProvider()),
//          ChangeNotifierProvider(create: (_) => DetailsProvider()),
//          ChangeNotifierProvider(create: (_) => FavoritesProvider()),
//          ChangeNotifierProvider(create: (_) => GenreProvider()),
      ],
      child: MyApp(),
    ),
  );
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
        builder: (BuildContext context, AppProvider appProvider, Widget child) {
      return MaterialApp(
        key: appProvider.key,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: themeData(appProvider.theme),
        darkTheme: themeData(ThemeConfig.darkTheme),
        home: HomeScreen(),
      );
    });
  }

  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: theme.textTheme,
      canvasColor: Colors.transparent,
    );
  }
}
