import 'package:cv_builder/screens/auth_screens/LoginScreen.dart';
import 'package:cv_builder/utils/helper.dart';
import 'package:cv_builder/utils/local_storage.dart';
import 'package:flutter/material.dart';

class Settingsscreen extends StatefulWidget {
  static const routeName = "/settings";
  const Settingsscreen({Key? key}) : super(key: key);

  @override
  State<Settingsscreen> createState() => _SettingsscreenState();
}

class _SettingsscreenState extends State<Settingsscreen> {
  final LocalStorage localStorage = LocalStorage();

  handleLogout() {
    localStorage.clearData();
    Helper().navigateAndClearStack(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: Icon(Icons.contact_page, size: 30),
                title: Text('Contact Us'),
                onTap: () {},
              ),
            ),
            const Divider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: Icon(Icons.privacy_tip, size: 30),
                title: Text('About'),
                onTap: () {},
              ),
            ),
            const Divider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: Icon(Icons.privacy_tip, size: 30),
                title: Text('Licenses'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LicensePage(),
                  ));
                },
              ),
            ),
            const Divider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: RotationTransition(
                  turns: AlwaysStoppedAnimation(180 / 360),
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
                title: Text('Logout'),
                onTap: () => handleLogout(),
              ),
            ),
          ],
        ));
  }
}
