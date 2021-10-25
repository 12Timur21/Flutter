import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/models/darkModeModel.dart';
import 'package:provider_test/providers/user.dart';

class Settings extends StatefulWidget {
  Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    bool isDarkMode = Provider.of<DarkModeModel>(context).isDarkMode;

    String? updatedUserName;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Container(
        decoration:
            BoxDecoration(color: isDarkMode ? Colors.black : Colors.white),
        child: Center(
            child: Column(
          children: [
            TextButton.icon(
                onPressed: () {
                  Provider.of<DarkModeModel>(context, listen: false).toogle();
                },
                icon: Icon(Icons.color_lens),
                label: Text('Toogle dark/light mode')),
          ],
        )),
      ),
    );
  }
}
