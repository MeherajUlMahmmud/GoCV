import 'package:gocv/screens/auth_screens/login_screen.dart';
import 'package:gocv/screens/utility_screens/account_settings_screen.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/local_storage.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = Constants.settingsScreenRouteName;

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.only(left: 10.0),
            child: Container(
              margin: const EdgeInsets.only(left: 5.0),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          SettingsListItem(
            title: 'Account',
            icon: Icons.account_box_outlined,
            onTap: () {
              Navigator.of(context).pushNamed(
                AccountSettingsScreen.routeName,
              );
            },
          ),
          const Divider(),
          SettingsListItem(
            title: 'Contact Us',
            icon: Icons.contact_page_outlined,
            onTap: () {},
          ),
          const Divider(),
          SettingsListItem(
            title: 'About',
            icon: Icons.privacy_tip,
            onTap: () {},
          ),
          const Divider(),
          SettingsListItem(
            title: 'Licenses',
            icon: Icons.privacy_tip,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const LicensePage(),
              ));
            },
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
      ),
    );
  }
}

class SettingsListItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function()? onTap;

  const SettingsListItem({
    required this.title,
    required this.icon,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: Icon(icon, size: 30),
        title: Text(title),
        onTap: onTap,
        // onTap: () {
        //   Navigator.of(context).pushNamed(
        //     AccountSettingsScreen.routeName,
        //   );
        // },
      ),
    );
  }
}
