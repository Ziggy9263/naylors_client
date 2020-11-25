import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/models/models.dart';

// TODO: Check for tax exemption automatically, fill in name and address in payment

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          BlocProvider.of<AuthBloc>(context).add(AuthGet());
        }
        if (state is AuthSuccess) {
          return Center(
            child: Column(
              children: <Widget>[
                Text('${state.auth.email}'),
              ],
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
