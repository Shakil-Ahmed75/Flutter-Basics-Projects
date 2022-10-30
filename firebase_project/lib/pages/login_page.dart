import 'package:flutter/material.dart';
import 'package:flutter_04_05/firebase_helper/authentication_helper.dart';
import 'package:flutter_04_05/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email, password;
  String _errMsg = '';
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  String uid;
  void _authenticate() async {
    if(_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }

    try{
      if(isLogin) {
        uid = await AuthenticationHelper.login(email, password);
      }else{
        uid = await AuthenticationHelper.register(email, password);
      }

      if(uid != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomePage()
        ));
      }
    }catch (error) {
      setState(() {
        _errMsg = error.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    keyboardType:TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter email address'
                    ),
                    validator: (value) {
                      if(value.isEmpty) {
                        return 'Provide a valid email address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value;
                    },
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter password'
                    ),
                    validator: (value) {
                      if(value.isEmpty) {
                        return 'Provide a password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      password = value;
                    },
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        child: Text('Register'),
                        onPressed: () {
                          setState(() {
                            isLogin = false;
                          });
                          _authenticate();
                        },
                      ),
                      RaisedButton(
                        child: Text('Login'),
                        onPressed: _authenticate,
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Text(_errMsg, style: TextStyle(fontSize: 16, color: Theme.of(context).errorColor),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
