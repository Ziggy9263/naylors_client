import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final appTitle = 'Naylor\'s Farm and Ranch Supply';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: NaylorsHomePage(title: appTitle),
    );
  }
}

class NaylorsHomePage extends StatefulWidget {
  final String title;

  NaylorsHomePage({Key key, this.title}) : super(key: key);

  @override
  _NaylorsHomePageState createState() => _NaylorsHomePageState(title);
}

class _NaylorsHomePageState extends State<NaylorsHomePage> {
  final String title;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _NaylorsHomePageState(this.title);

  void _openEndDrawer() {
    _scaffoldKey.currentState.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(title), actions: <Widget>[
        IconButton(
            onPressed: _openEndDrawer,
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
      ]),
      body: Center(child: Text('In Development')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('old_naylors.jpg'), fit: BoxFit.cover),
              ),
              child: Text('Navigation'),
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
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.blueGrey),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: Text('Cart goes here'),
      ),
    );
  }
}
