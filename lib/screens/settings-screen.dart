import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../locale/locale_controller.dart';
import '../providers/auth.dart';
import '../widgets/my_app_bar.dart';

SharedPreferences? sharedpref;
MyLocaleController controller = Get.find();

List<Map<String, String>> _languages = [
  {'name': 'English', 'locale': 'en'},
  {'name': 'عربي', 'locale': 'ar'}
];

Map<String, String> _selectedLanguage =
    sharedpref?.getString("curruntLang") == 'ar'
        ? _languages[1]
        : _languages[0];

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: Text("settings".tr),
        context: context,
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Change Language'),
            trailing: DropdownButton<Map<String, String>>(
              value: _selectedLanguage,
              items:
                  _languages.map<DropdownMenuItem<Map<String, String>>>((lang) {
                return DropdownMenuItem<Map<String, String>>(
                  value: lang,
                  child: Text(lang['name']!),
                );
              }).toList(),
              onChanged: (value) {
                // Handle changing language here
                _selectedLanguage = value!;
                // You can save the selected language to shared preferences or a database here
                String localeCode = _selectedLanguage['locale']!;
                controller.changeLang(localeCode);
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Turn on Notifications'),
            onTap: () {
              // Handle turning on notifications here
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              // Navigator.pop(context);
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
