import 'package:cv_builder/screens/homescreen.dart';
import 'package:cv_builder/view_models/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
        builder: (BuildContext context, AppProvider appProvider, Widget child) {
      return MaterialApp(
        key: appProvider.key,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.dark,
          backgroundColor: Colors.black,
          primarySwatch: Colors.blue,
          primaryColor: Colors.black,
          accentColor: Colors.blueAccent,
          cursorColor: Colors.blueAccent,
          tabBarTheme: TabBarTheme(
            labelColor: Colors.black,
            labelStyle: TextStyle(color: Colors.white),
            unselectedLabelColor: Colors.grey,
            unselectedLabelStyle: TextStyle(color: Colors.grey),
          ),
          scaffoldBackgroundColor: Colors.black,
          dividerColor: Colors.black54,
        ),
        home: HomeScreen(),
      );
    });
  }
}
