import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/widgets/widgets.dart';

class NaylorsHomePage extends StatefulWidget {
  final String title;

  NaylorsHomePage({Key key, this.title}) : super(key: key);

  @override
  NaylorsHomePageState createState() => NaylorsHomePageState(title);
}

class NaylorsHomePageState extends State<NaylorsHomePage> {
  final String title;
  String _email = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  NaylorsHomePageState(this.title);

  @override
  void initState() {
    super.initState();
    _loadAuthInfo();
  }

  _loadAuthInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('email');
    });
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.remove('token');
      prefs.remove('email');
      prefs.remove('isAdmin');
    });
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  void _openEndDrawer() {
    _scaffoldKey.currentState.openEndDrawer();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(title), actions: <Widget>[
        CartBadge(
          style: style,
          onPressed: _openEndDrawer,
        ),
      ]),
      body: ProductListBody(this),
      drawer: MainNavDrawer(),
      endDrawer: CartBody(parent: this),
    );
  }
}
