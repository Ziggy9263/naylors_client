import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:naylors_client/login.dart';
import 'package:naylors_client/register.dart';
import 'package:naylors_client/products.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final appTitle = 'Naylor\'s Online';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: appTitle,
      initialRoute: '/', // Skipping login for now TODO: Don't forget to revert
      onGenerateRoute: (RouteSettings settings) {
        var routes = <String, WidgetBuilder>{
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/': (context) => NaylorsHomePage(title: appTitle),
          '/product': (context) => ProductDetailScreen(initProduct: settings.arguments),
        };
        WidgetBuilder builder = routes[settings.name];
        return MaterialPageRoute(builder: (context) => builder(context));
      }
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
  String _email = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _NaylorsHomePageState(this.title);

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
      body: ProductsBody(),
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
                    child: Text((_email) ?? "Not Available"),
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
                Navigator.pop(context);
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
      endDrawer: Drawer(
        child: Text('Cart goes here'),
      ),
    );
  }
}
