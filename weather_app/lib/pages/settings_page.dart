import 'package:flutter/material.dart';
import 'package:weather_app_batch04/utils/weather_utils.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool status = false;

  @override
  void initState() {
    getTempStatus().then((value) {
      setState(() {
        status = value;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: Text('Change temperature to Fahrenheit'),
            subtitle: Text('Default is Celsius'),
            value: status,
            onChanged: (value) async {
              setState(() {
                status = value;
              });
              await saveTempStatus(status);
            },
          ),
        ],
      ),
    );
  }
}
