import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/widgets/widgets.dart';

class NaylorsHomePage extends StatefulWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;

  NaylorsHomePage({Key key, this.title, this.scaffoldKey}) : super(key: key);

  @override
  NaylorsHomePageState createState() =>
      NaylorsHomePageState(title, scaffoldKey);
}

class NaylorsHomePageState extends State<NaylorsHomePage> {
  final String title;
  String _email;
  final GlobalKey<ScaffoldState> scaffoldKey;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  NaylorsHomePageState(this.title, this.scaffoldKey);

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
    scaffoldKey.currentState.openEndDrawer();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(elevation: 0, title: Text(title), actions: <Widget>[
        CartBadge(
          style: style,
          onPressed: _openEndDrawer,
        ),
      ]),
      body: BlocBuilder<NavigatorBloc, NaylorsNavigatorState>(
          builder: (context, state) {
        if (state is NavigatorInitial || state is NavigatorAtProducts) {
          return ProductListBody(this);
        }
        if (state is NavigatorAtOrders) {
          return OrderPage();
        }
        if (state is NavigatorAtProfile) {
          return ProfilePage();
        }
        return Center(child: CircularProgressIndicator());
      }),
      drawer: MainNavDrawer(),
      endDrawer: CartBody(parent: this),
    );
  }
}
