import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/models/models.dart';

class RegisterPage extends StatefulWidget {
  final AuthInfo auth;
  RegisterPage(this.auth) : assert(auth != null);
  @override
  _RegisterPageState createState() => _RegisterPageState(auth);
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthInfo auth;
  _RegisterPageState(this.auth);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final phone = TextEditingController();
  final business = TextEditingController();
  final address = TextEditingController();
  final addrState = TextEditingController();
  final addrZip = TextEditingController();
  FocusNode nameFocus,
      phoneFocus,
      businessFocus,
      addressFocus,
      addrStateFocus,
      addrZipFocus;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    business.dispose();
    address.dispose();
    addrState.dispose();
    addrZip.dispose();
    nameFocus.dispose();
    phoneFocus.dispose();
    businessFocus.dispose();
    addressFocus.dispose();
    addrStateFocus.dispose();
    addrZipFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameFocus = FocusNode();
    phoneFocus = FocusNode();
    businessFocus = FocusNode();
    addressFocus = FocusNode();
    addrStateFocus = FocusNode();
    addrZipFocus = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthInProgress) {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlue,
              ));
            }
            if (state is AuthSuccess) {
              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                Navigator.pushReplacementNamed(context, '/');
              });
            }
            if (state is AuthFailure) {
              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text('Registration Failed, ${state.error}'),
                  action: SnackBarAction(
                    label: 'Dismiss',
                    onPressed: () {},
                  ),
                ));
                BlocProvider.of<AuthBloc>(context).add(AuthReset());
              });
            }
            return Center(
              child: Container(
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
                              controller: phone,
                              obscureText: false,
                              focusNode: phoneFocus,
                              textInputAction: TextInputAction.next,
                              style: style,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                hintText: "Phone Number",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                                errorMaxLines: 3,
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your phone number';
                                }

                                return null;
                              },
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                                controller: business,
                                obscureText: false,
                                focusNode: businessFocus,
                                textInputAction: TextInputAction.next,
                                style: style,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  hintText: "Business Name (Optional)",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                  errorMaxLines: 3,
                                ),
                                validator: (_) => null),
                            SizedBox(height: 20.0),
                            TextFormField(
                              controller: address,
                              obscureText: false,
                              focusNode: addressFocus,
                              textInputAction: TextInputAction.next,
                              style: style,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                hintText: "Billing Address (Optional)",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                                errorMaxLines: 3,
                              ),
                              validator: (_) => null,
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              controller: addrState,
                              obscureText: false,
                              focusNode: addrStateFocus,
                              textInputAction: TextInputAction.next,
                              style: style,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                hintText: "State",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                                errorMaxLines: 3,
                              ),
                              validator: (_) => null,
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              controller: addrZip,
                              obscureText: false,
                              focusNode: addrZipFocus,
                              textInputAction: TextInputAction.next,
                              style: style,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                hintText: "Zip Code",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                                errorMaxLines: 3,
                              ),
                              validator: (_) => null,
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
                                        auth.email, name.text,
                                        phone: phone.text,
                                        business: business.text,
                                        address: address.text,
                                        addrState: addrState.text,
                                        addrZip: addrZip.text);
                                    BlocProvider.of<AuthBloc>(context)
                                        .add(AuthRegister(auth: registerInfo));
                                  }
                                },
                                child: Text(
                                  "Register",
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
              ),
            );
          },
        ));
  }
}
