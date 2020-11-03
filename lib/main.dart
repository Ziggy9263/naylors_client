import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:badges/badges.dart';

import 'package:naylors_client/login.dart';
import 'package:naylors_client/register.dart';
//import 'package:naylors_client/products.dart';
//import 'package:naylors_client/cart.dart';
//import 'package:naylors_client/checkout.dart';
import 'package:naylors_client/models/models.dart';

import 'package:naylors_client/simple_bloc_observer.dart';
import 'package:bloc/bloc.dart';
import 'package:naylors_client/repositories/repositories.dart';
import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/widgets/widgets.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();

  final ProductRepository productRepository = ProductRepository(
    productApiClient: ProductApiClient(
      httpClient: http.Client(),
    ),
  );

  final CartRepository cartRepository = CartRepository(
    detail: List<CartItem>(),
  );

  runApp(MyApp(productRepository: productRepository, cartRepository: cartRepository));
}

class MyApp extends StatelessWidget {
  final ProductRepository productRepository;
  final CartRepository cartRepository;

  MyApp({
    Key key,
    @required this.productRepository,
    @required this.cartRepository
  })  : assert(productRepository != null),
        super(key: key);

  final appTitle = 'Naylor\'s Online';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      initialRoute:
          '/', // Skipping login for now TODO: Don't forget to revert
      onGenerateRoute: (RouteSettings settings) {
        var routes = <String, WidgetBuilder>{
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<ProductListBloc>(
                    create: (BuildContext context) =>
                      ProductListBloc(productRepository: productRepository),
                  ),
                  BlocProvider<CartBloc>(
                    lazy: false,
                    create: (BuildContext context) =>
                      CartBloc(cartRepository: cartRepository),
                  ),
                ],
                child: NaylorsHomePage(title: appTitle),
              ),
          '/product': (context) => BlocProvider(
                create: (context) =>
                    ProductBloc(productRepository: productRepository),
                child: ProductDetailBody(settings.arguments),
              ),
          //'/product': (context) =>
          //    ProductDetailScreen(initProduct: settings.arguments),
          //'/checkout': (context) => CheckoutPage(),
        };
        WidgetBuilder builder = routes[settings.name];
        return MaterialPageRoute(builder: (context) => builder(context));
      },
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
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

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
        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            return Badge(
              badgeContent: Text(
                (state is CartNotEmpty) ? state.cart.length.toString() : "0",
                //cartDetail.cart.length.toString(),
                style: style.copyWith(color: Colors.white, fontSize: 14),
              ),
              //showBadge: (cartDetail.cart.length > 0) ? true : false,
              position: BadgePosition.topEnd(top: 2, end: 2),
              child: IconButton(
                onPressed: _openEndDrawer,
                icon: Icon(
                  Icons.shopping_cart,
                  size: 36,
                  color: Colors.white,
                ),
              ),
            );
          }
        ),
      ]),
      body: ProductListBody(),
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
      endDrawer: Text("Working on it"), //CartBody(),
    );
  }
}
