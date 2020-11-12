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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('old_naylors.jpg'), fit: BoxFit.cover),
              ),
              child: Align(
                alignment: FractionalOffset.bottomLeft,
                child: Material(
                  elevation: 1.0,
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white70,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5.0, 3.0, 5.0, 3.0),
                    child: Text(
                        BlocProvider.of<AuthBloc>(context).email ??
                            "Not Available"),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.store, color: Colors.blueGrey),
              title: Text('Products'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.filter_list, color: Colors.blueGrey),
              title: Text('Categories'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.credit_card, color: Colors.blueGrey),
              title: Text('Orders'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(
              color: Colors.grey,
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            ListTile(
              leading: Icon(Icons.account_box, color: Colors.blueGrey),
              title: Text('Profile'),
              onTap: () {
                Navigator.of(context).pushNamed('/profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.blueGrey),
              title: Text('Logout'),
              onTap: () {
                _logout();
              },
            ),
          ],
        ),
      ),
      endDrawer: CartBody(parent: this),
    );
  }
}
