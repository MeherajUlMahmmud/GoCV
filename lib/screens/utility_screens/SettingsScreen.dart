import 'package:gocv/screens/auth_screens/LoginScreen.dart';
import 'package:gocv/screens/utility_screens/AccountSettingsScreen.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/local_storage.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = "/settings";
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final LocalStorage localStorage = LocalStorage();

  handleLogout() {
    localStorage.clearData();
    Helper().navigateAndClearStack(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: const Icon(Icons.account_box_outlined, size: 30),
                title: const Text('Account'),
                onTap: () {
                  // Navigator.of(context).pushNamed(
                  //   AccountSettingsScreen.routeName,
                  // );
                },
              ),
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: const Icon(Icons.contact_page_outlined, size: 30),
                title: const Text('Contact Us'),
                onTap: () {},
              ),
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: const Icon(Icons.privacy_tip, size: 30),
                title: const Text('About'),
                onTap: () {},
              ),
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: const Icon(Icons.privacy_tip, size: 30),
                title: const Text('Licenses'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LicensePage(),
                  ));
                },
              ),
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: const RotationTransition(
                  turns: AlwaysStoppedAnimation(180 / 360),
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
                title: const Text('Logout'),
                onTap: () => handleLogout(),
              ),
            ),
          ],
        ));
  }
}
