import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/models/models.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final email = TextEditingController();
  final password = TextEditingController();
  FocusNode emailFocus;
  FocusNode passFocus;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          if (state is AuthInitial) {
            return Center(
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
                        TextField(
                          controller: email,
                          obscureText: false,
                          style: style,
                          focusNode: emailFocus,
                          autofocus: true,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) => passFocus.requestFocus(),
                        ),
                        SizedBox(height: 25.0),
                        TextField(
                          controller: password,
                          obscureText: true,
                          style: style,
                          focusNode: passFocus,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) {
                            var loginInfo =
                                AuthLoginInfo(email.text, password.text);
                            BlocProvider.of<AuthBloc>(context)
                                .add(AuthLogin(loginInfo));
                          },
                        ),
                        SizedBox(height: 35.0),
                        Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.blue,
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            padding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            onPressed: () {
                              var loginInfo =
                                  AuthLoginInfo(email.text, password.text);
                              BlocProvider.of<AuthBloc>(context)
                                  .add(AuthLogin(loginInfo));
                            },
                            child: Text(
                              "Login",
                              textAlign: TextAlign.center,
                              style: style.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.white,
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            padding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            onPressed: () async {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: Text(
                              "Register",
                              textAlign: TextAlign.center,
                              style: style.copyWith(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          if (state is AuthInProgress) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is AuthSuccess) {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.pushReplacementNamed(context, '/');
            });
          }
          if (state is AuthFailure) {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text('Incorrect Username/Password.'),
                action: SnackBarAction(
                  label: 'Dismiss',
                  onPressed: () {},
                ),
              ));
              BlocProvider.of<AuthBloc>(context).add(AuthReset());
            });
          }
          return Center(child: CircularProgressIndicator());
        }));
  }
}
