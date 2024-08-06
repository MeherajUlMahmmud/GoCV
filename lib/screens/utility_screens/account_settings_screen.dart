import 'package:flutter/material.dart';
import 'package:gocv/screens/utility_screens/email_update_screen.dart';
import 'package:gocv/utils/constants.dart';

class AccountSettingsScreen extends StatefulWidget {
  static const routeName = Constants.accountSettingsScreenRouteName;

  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Account Settings',
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
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
              title: 'Update Email Address',
              icon: Icons.email_outlined,
              onTap: () {
                Navigator.of(context).pushNamed(
                  EmailUpdateScreen.routeName,
                );
              },
            ),
            const Divider(),
          ],
        ));
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
