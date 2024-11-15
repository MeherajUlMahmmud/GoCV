import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        appBar: AppBar(
          title:  Text(
            AppLocalizations.of(context)!.update_email_address,
          ),
        ),
        body: ListView(
          children: [
            SettingsListItem(
              title: AppLocalizations.of(context)!.update_email_address,
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
