import 'package:flutter/material.dart';

class Settingsscreen extends StatefulWidget {
  static const routeName = "/settings";
  const Settingsscreen({Key? key}) : super(key: key);

  @override
  State<Settingsscreen> createState() => _SettingsscreenState();
}

class _SettingsscreenState extends State<Settingsscreen> {
  List items = [
    {
      'icon': Icon(Icons.contact_page, size: 30),
      'title': 'Contact Us',
      // 'function': () => showAbout(),
    },
    {
      'icon': Icon(Icons.privacy_tip, size: 30),
      'title': 'About',
      // 'function': () => showAbout(),
    },
    {
      'icon': Icon(Icons.privacy_tip, size: 30),
      'title': 'Licenses',
      'function': (context) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => LicensePage(),
        ));
      }
    },
    {
      'icon': RotationTransition(
        turns: AlwaysStoppedAnimation(180 / 360),
        child: Icon(
          Icons.exit_to_app,
          color: Colors.red,
          size: 30,
        ),
      ),
      'title': 'Logout',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () => items[index]['function'](context),
            leading: items[index]['icon'],
            title: Text(items[index]['title'], style: TextStyle(fontSize: 18)),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      ),
    );
  }
}
