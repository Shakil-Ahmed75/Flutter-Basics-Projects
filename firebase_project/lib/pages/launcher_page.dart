import 'package:flutter/material.dart';
import 'package:flutter_04_05/firebase_helper/authentication_helper.dart';
import 'package:flutter_04_05/pages/home_page.dart';
import 'package:flutter_04_05/pages/login_page.dart';

class LauncherPage extends StatefulWidget {
  @override
  _LauncherPageState createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  @override
  void initState() {
    //check if firebase user is logged in or not
    AuthenticationHelper.user.then((user) {
      user == null ?
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => LoginPage()
          )) :
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePage()
      ));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    );
  }
}
