import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gocv/providers/settings_provider.dart';
import 'package:gocv/screens/auth_screens/login_screen.dart';
import 'package:gocv/screens/utility_screens/account_settings_screen.dart';
import 'package:gocv/utils/constants.dart';
import 'package:gocv/utils/helper.dart';
import 'package:gocv/utils/local_storage.dart';
import 'package:provider/provider.dart';

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
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settings,
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.only(left: 10.0),
            child: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          SettingsListItem(
            title: AppLocalizations.of(context)!.account,
            icon: Icons.account_box_outlined,
            onTap: () {
              Navigator.of(context).pushNamed(
                AccountSettingsScreen.routeName,
              );
            },
          ),
          const Divider(),
          SettingsListItem(
            title: AppLocalizations.of(context)!.contact_us,
            icon: Icons.contact_page_outlined,
            onTap: () {},
          ),
          const Divider(),
          SettingsListItem(
            title: AppLocalizations.of(context)!.aboutUs,
            icon: Icons.privacy_tip,
            onTap: () {},
          ),
          const Divider(),
          SettingsListItem(
            title: AppLocalizations.of(context)!.licenses,
            icon: Icons.privacy_tip,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const LicensePage(),
              ));
            },
          ),
          const Divider(),

          // Theme Toggle Option
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: SwitchListTile(
              title: Text(AppLocalizations.of(context)!.darkMode),
              value: settingsProvider.themeMode == ThemeMode.dark,
              onChanged: (bool value) {
                settingsProvider.setThemeMode(
                  value ? ThemeMode.dark : ThemeMode.light,
                );
              },
              secondary: const Icon(Icons.dark_mode),
            ),
          ),
          const Divider(),

          // Language Selection Option
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: const Icon(Icons.language),
              title: Text(AppLocalizations.of(context)!.language),
              trailing: DropdownButton<String>(
                value: settingsProvider.language,
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'bn', child: Text('বাংলা')),
                  // Add other languages as needed
                ],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    settingsProvider.setLanguage(newValue);
                  }
                },
              ),
            ),
          ),
          const Divider(),

          // Logout Option
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
              title: Text(AppLocalizations.of(context)!.logout),
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
      ),
    );
  }
}
