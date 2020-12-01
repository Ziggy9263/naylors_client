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
  String headerTitle = "Naylor's Online: Products";
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
        appBar: BlocProvider.of<NavigatorBloc>(context).appBarToggle ? AppBar(
            backgroundColor: Colors.lightBlue,
            elevation: 0,
            title: Text(headerTitle),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Material(
                      shape: CircleBorder(),
                      color:
                          (BlocProvider.of<NavigatorBloc>(context).searchToggle)
                              ? Colors.white
                              : Colors.transparent,
                      child: IconButton(
                        icon: Icon(
                          Icons.search,
                          size: 36.0,
                          color: (BlocProvider.of<NavigatorBloc>(context)
                                  .searchToggle)
                              ? Colors.black54
                              : Colors.white,
                        ),
                        onPressed: () {
                          BlocProvider.of<NavigatorBloc>(context)
                              .add(NavigatorToSearch());
                          BlocProvider.of<SearchBloc>(context)
                              .add(SearchInit());
                          setState(() => {
                                headerTitle =
                                    (BlocProvider.of<NavigatorBloc>(context)
                                            .searchToggle)
                                        ? "Naylor's Online: Products"
                                        : "Naylor's Online: Search"
                              });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 2, 0),
                child: CartBadge(
                    style: style,
                    onPressed: () {
                      BlocProvider.of<NavigatorBloc>(context)
                          .add(NavigatorToCart());
                      setState(() => {
                            headerTitle =
                                (BlocProvider.of<NavigatorBloc>(context)
                                        .cartToggle)
                                    ? "Naylor's Online: Products"
                                    : "Naylor's Online: Your Cart"
                          });
                    }),
              ),
            ]) : null,
        body: BlocBuilder<NavigatorBloc, NaylorsNavigatorState>(
            builder: (context, state) {
          if (state is NavigatorInitial || state is NavigatorAtProducts) {
            return ProductListBody(this);
          }
          if (state is NavigatorAtOrders) {
            return OrderPage(this);
          }
          if (state is NavigatorAtProfile) {
            return ProfilePage();
          }
          if (state is NavigatorAtCart) {
            return CartBody(parent: this);
          }
          if (state is NavigatorAtProduct) {
            return ProductDetailBody(this, state.product);
          }
          if (state is NavigatorAtSearch) {
            return SearchPage(this);
          }
          if (state is NavigatorAtCheckout) {
            return CheckoutPage(this);
          }
          if (state is NavigatorAtPayment) {
            return CheckoutPayment(
                cart: BlocProvider.of<CartBloc>(context).cartRepository.detail);
          }
          return Center(child: CircularProgressIndicator());
        }),
        drawer: MainNavDrawer(parent: this));
  }
}
