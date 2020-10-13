import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:naylors_client/api.dart';
import 'dart:async';
//import 'package:shared_preferences/shared_preferences.dart';
// TODO: Auto-login after registration.

class RegisterInfo {
  final String email;
  final String password;
  final String name;
  final String phone;
  final String business;
  final String address;
  final String taxExempt;

  RegisterInfo(this.email, this.password, this.name,
      [this.phone, this.business, this.address, this.taxExempt]);
}

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
    final nameField = TextFormField(
      controller: name,
      obscureText: false,
      focusNode: nameFocus,
      textInputAction: TextInputAction.next,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
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
    );
    final emailField = TextFormField(
      controller: email,
      obscureText: false,
      focusNode: emailFocus,
      textInputAction: TextInputAction.next,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
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
    );
    final passField = TextFormField(
      controller: password,
      obscureText: true,
      focusNode: passFocus,
      textInputAction: TextInputAction.next,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        errorMaxLines: 3,
      ),
      validator: (value) {
        RegExp passExp =
            new RegExp(r"^((?=\S*?[A-Z])(?=\S*?[a-z])(?=\S*?[0-9]).{6,})\S$");
        if (value.isEmpty) {
          return 'Please enter a password';
        }
        if (!passExp.hasMatch(value)) {
          return 'Must have a minimum of 6 characters, at least 1 uppercase letter, 1 lowercase letter, and 1 number with no spaces';
        }

        return null;
      },
    );
    final passCheckField = TextFormField(
        controller: passCheck,
        obscureText: true,
      focusNode: passCheckFocus,
      textInputAction: TextInputAction.done,
        style: style,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
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
        });
    final createAccountButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            var registerInfo =
                RegisterInfo(email.text, password.text, name.text);
            final response = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RegisterLoadingScreen(registerInfo: registerInfo),
                ));
            if (response['pass']) {
              Navigator.pop(context, response['result']);
            }
            //_scaffoldKey.currentState.showSnackBar(response['result']);
            //Navigator.pushReplacementNamed(context, '/');
          }
        },
        child: Text(
          "Create Account",
          textAlign: TextAlign.center,
          style: style.copyWith(
              color: Colors.white, fontWeight: FontWeight.normal),
        ),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      body: Center(
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
                    nameField,
                    SizedBox(height: 20.0),
                    emailField,
                    SizedBox(height: 20.0),
                    passField,
                    SizedBox(height: 20.0),
                    passCheckField,
                    SizedBox(height: 35.0),
                    createAccountButton,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterLoadingScreen extends StatefulWidget {
  final RegisterInfo registerInfo;

  @override
  _RegisterLoadingScreenState createState() =>
      _RegisterLoadingScreenState(registerInfo);

  RegisterLoadingScreen({Key key, @required this.registerInfo})
      : super(key: key);
}

class _RegisterLoadingScreenState extends State<RegisterLoadingScreen> {
  final RegisterInfo registerInfo;
  Future<AuthInfo> _futureAuth;

  _RegisterLoadingScreenState(this.registerInfo);

  void initState() {
    super.initState();
    setState(() {
      _futureAuth = register(this.registerInfo.email,
          this.registerInfo.password, this.registerInfo.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final registerSuccessSnackBar = SnackBar(
      content: Text('Successfully Created Account!'),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {},
      ),
    );
    final registerErrorSnackBar = SnackBar(
      content: Text('An Error Occured While Creating Account.'),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {},
      ),
    );
    return FutureBuilder<AuthInfo>(
      future: _futureAuth,
      builder: (context, snapshot) {
        var response = Map<String, dynamic>();
        if (snapshot.hasData) {
          //return Text(snapshot.data.token);
          response['pass'] = true;
          response['result'] = registerSuccessSnackBar;
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.pop(context, response);
          });
        } else if (snapshot.hasError) {
          response['pass'] = false;
          response['result'] = registerErrorSnackBar;
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.pop(context, response);
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
