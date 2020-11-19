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
  String headerTitle = "";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.lightBlue,
        appBar: AppBar(
            backgroundColor: Colors.lightBlue,
            elevation: 0,
            title: Text(headerTitle),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 2, 0),
                child: CartBadge(
                    style: style,
                    onPressed: () {
                      BlocProvider.of<NavigatorBloc>(context)
                          .add(NavigatorToCart());
                      setState(() => {
                        headerTitle = (BlocProvider.of<NavigatorBloc>(context).cartToggle) ? "Naylor's Online: Products" : "Naylor's Online: Your Cart"
                      });
                    }),
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
          if (state is NavigatorAtCart) {
            return CartBody(parent: this);
          }
          return Center(child: CircularProgressIndicator());
        }),
        drawer: MainNavDrawer(parent: this));
  }
}
