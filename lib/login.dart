import 'package:flutter/material.dart';
import 'package:naylors_client/api.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  Future<AuthInfo> _futureAuth;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String _token;
  String _email;
  bool _isAdmin;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadAuthInfo();
    if (_token != null) Navigator.pushReplacementNamed(context, '/');
  }

  _loadAuthInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = (prefs.getString('token') ?? null);
      _email = (prefs.getString('email') ?? null);
      _isAdmin = (prefs.getBool('isAdmin') ?? false);
    });
  }

  _setAuthInfo(String token, String email, bool isAdmin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('token', token);
      prefs.setString('email', email);
      prefs.setBool('isAdmin', isAdmin);
    });
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      controller: email,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );
    final passField = TextField(
      controller: password,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );
    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          _futureAuth = login(email.text, password.text);
        },
        child: Text(
          "Login",
          textAlign: TextAlign.center,
          style:
              style.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/');
        },
        child: Text(
          "Register",
          textAlign: TextAlign.center,
          style:
              style.copyWith(color: Colors.blue, fontWeight: FontWeight.normal),
        ),
      ),
    );
    final loginErrorSnackBar = SnackBar(
      content: Text('Incorrect Username/Password.'),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {},
      ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: FutureBuilder<AuthInfo>(
              future: _futureAuth,
              builder: (context, snapshot) {
                if (_futureAuth == null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 205.0,
                        child: Image.asset(
                          "assets/logo.jpg",
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 45.0),
                      emailField,
                      SizedBox(height: 25.0),
                      passField,
                      SizedBox(height: 35.0),
                      loginButton,
                      SizedBox(height: 15.0),
                      registerButton,
                    ],
                  );
                }
                if (snapshot.hasData) {
                  //return Text(snapshot.data.token);
                  Navigator.pushReplacementNamed(context, '/');
                } else if (snapshot.hasError) {
                  _futureAuth = null;
                  Scaffold.of(context).showSnackBar(loginErrorSnackBar);
                }

                return CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }
}
