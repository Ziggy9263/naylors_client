import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/models/models.dart';

// TODO: Auto-login after registration.

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final passCheck = TextEditingController();
  FocusNode nameFocus, emailFocus, passFocus, passCheckFocus;
  /*final phone = TextEditingController();
  final business = TextEditingController();
  final address = TextEditingController();
  final taxExempt = TextEditingController();*/
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    name.dispose();
    nameFocus.dispose();
    emailFocus.dispose();
    passFocus.dispose();
    passCheckFocus.dispose();
    /*phone.dispose();
    business.dispose();
    address.dispose();
    taxExempt.dispose();*/
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameFocus = FocusNode();
    emailFocus = FocusNode();
    passFocus = FocusNode();
    passCheckFocus = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthInitial) {
              return Center(
                child: Form(
                  key: _formKey,
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(36.0),
                      child: FocusScope(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              controller: name,
                              obscureText: false,
                              focusNode: nameFocus,
                              textInputAction: TextInputAction.next,
                              style: style,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                hintText: "Full Name (e.g. Zane Grey)",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                                errorMaxLines: 3,
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your name';
                                }

                                return null;
                              },
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              controller: email,
                              obscureText: false,
                              focusNode: emailFocus,
                              textInputAction: TextInputAction.next,
                              style: style,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                              validator: (value) {
                                RegExp emailExp = new RegExp(
                                    r"^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$");
                                if (value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!emailExp.hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              controller: password,
                              obscureText: true,
                              focusNode: passFocus,
                              textInputAction: TextInputAction.next,
                              style: style,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                                errorMaxLines: 3,
                              ),
                              validator: (value) {
                                RegExp passExp = new RegExp(
                                    r"^((?=\S*?[A-Z])(?=\S*?[a-z])(?=\S*?[0-9]).{6,})\S$");
                                if (value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (!passExp.hasMatch(value)) {
                                  return 'Must have a minimum of 6 characters, at least 1 uppercase letter, 1 lowercase letter, and 1 number with no spaces';
                                }

                                return null;
                              },
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              controller: passCheck,
                              obscureText: true,
                              focusNode: passCheckFocus,
                              textInputAction: TextInputAction.done,
                              style: style,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                hintText: "Confirm Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != password.text) {
                                  return 'Passwords must match';
                                }
                                return null;
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
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    var registerInfo = AuthRegisterInfo(
                                        email.text, password.text, name.text);
                                    BlocProvider.of<AuthBloc>(context)
                                        .add(AuthRegister(auth: registerInfo));
                                  }
                                },
                                child: Text(
                                  "Create Account",
                                  textAlign: TextAlign.center,
                                  style: style.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                  content: Text('Registration Failed'),
                  action: SnackBarAction(
                    label: 'Dismiss',
                    onPressed: () {},
                  ),
                ));
                BlocProvider.of<AuthBloc>(context).add(AuthReset());
              });
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}
