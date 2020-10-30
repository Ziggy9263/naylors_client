import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:naylors_client/repositories/api.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class LoginInfo {
  final String email;
  final String password;

  LoginInfo(this.email, this.password);
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final email = TextEditingController();
  FocusNode emailFocus;
  FocusNode passFocus;
  final password = TextEditingController();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String _token;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    emailFocus.dispose();
    passFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadAuthInfo();
    if (_token != null) Navigator.pushReplacementNamed(context, '/');

    emailFocus = FocusNode();
    passFocus = FocusNode();
  }

  _loadAuthInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = (prefs.getString('token') ?? null);
    });
  }

  _loginButtonFunction() async {
    //_futureAuth = login(email.text, password.text);
    var loginInfo = LoginInfo(email.text, password.text);
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginLoadingScreen(loginInfo: loginInfo),
        ));
    _scaffoldKey.currentState.showSnackBar(result);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      controller: email,
      obscureText: false,
      style: style,
      focusNode: emailFocus,
      autofocus: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      textInputAction: TextInputAction.next,
      onSubmitted: (_) => passFocus.requestFocus(),
    );
    final passField = TextField(
      controller: password,
      obscureText: true,
      style: style,
      focusNode: passFocus,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      textInputAction: TextInputAction.send,
      onSubmitted: (_) {
        _loginButtonFunction();
      },
    );
    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: _loginButtonFunction,
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
        onPressed: () async {
          var result = await Navigator.pushNamed(context, '/register');
          _scaffoldKey.currentState.removeCurrentSnackBar();
          _scaffoldKey.currentState.showSnackBar(result);
        },
        child: Text(
          "Register",
          textAlign: TextAlign.center,
          style:
              style.copyWith(color: Colors.blue, fontWeight: FontWeight.normal),
        ),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: FocusScope(
              child: Column(
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginLoadingScreen extends StatefulWidget {
  final LoginInfo loginInfo;

  @override
  _LoginLoadingScreenState createState() => _LoginLoadingScreenState(loginInfo);

  LoginLoadingScreen({Key key, @required this.loginInfo}) : super(key: key);
}

class _LoginLoadingScreenState extends State<LoginLoadingScreen> {
  final LoginInfo loginInfo;
  Future<AuthInfo> _futureAuth;

  _LoginLoadingScreenState(this.loginInfo);

  void initState() {
    super.initState();
    setState(() {
      _futureAuth = login(this.loginInfo.email, this.loginInfo.password);
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginErrorSnackBar = SnackBar(
      content: Text('Incorrect Username/Password.'),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {},
      ),
    );
    return FutureBuilder<AuthInfo>(
      future: _futureAuth,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //return Text(snapshot.data.token);

          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.pushReplacementNamed(context, '/');
          });
        } else if (snapshot.hasError) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.pop(context, loginErrorSnackBar);
          });
        }

        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
