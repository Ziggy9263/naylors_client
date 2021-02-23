import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as FLNP;
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
  // ignore: unused_field
  String _email;
  String headerTitle = "Naylor's Online: Products";
  final GlobalKey<ScaffoldState> scaffoldKey;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  NaylorsHomePageState(this.title, this.scaffoldKey)
      : assert(scaffoldKey != null);

  @override
  void initState() {
    super.initState();
    _loadAuthInfo().then((value) => {_email = value});
  }

  Future<String> _loadAuthInfo() async {
    BlocProvider.of<AuthBloc>(context).add(AuthGet());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') ?? 'Guest';
  }

  // ignore: unused_element
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

  showSnackBar(SnackBar data) async {
    ScaffoldMessenger.of(context).showSnackBar(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        floatingActionButton:
            (BlocProvider.of<NavigatorBloc>(context).floatingButton != null)
                ? BlocProvider.of<NavigatorBloc>(context).floatingButton
                : null,
        backgroundColor: Colors.lightBlue,
        appBar: BlocProvider.of<NavigatorBloc>(context).appBarToggle
            ? AppBar(
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
                            color: (BlocProvider.of<NavigatorBloc>(context)
                                    .searchToggle)
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
                                          (BlocProvider.of<NavigatorBloc>(
                                                      context)
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
                  ])
            : null,
        body: BlocBuilder<NavigatorBloc, NaylorsNavigatorState>(
            builder: (context, state) {
          if (state is NavigatorInitial || state is NavigatorAtProducts) {
            return ProductListBody(this);
          }
          if (state is NavigatorAtCategories) {
            return CategoryPage(this);
          }
          if (state is NavigatorAtOrders) {
            return OrderPage(this);
          }
          if (state is NavigatorAtOrderEdit) {
            return OrderEditPage(this);
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
          if (state is NavigatorAtProductEdit) {
            return ProductEdit(this, state.product);
          }
          if (state is NavigatorAtSearch) {
            return SearchPage(this);
          }
          if (state is NavigatorAtCheckout) {
            return CheckoutPage(this);
          }
          if (state is NavigatorAtPayment) {
            return CheckoutPayment(
                parent: this,
                cart: BlocProvider.of<CartBloc>(context).cartRepository.detail,
                payOption: state.payOption);
          }
          if (state is NavigatorAtDebug) {
            return Column(children: <Widget>[
              IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    FLNP.FlutterLocalNotificationsPlugin flip =
                        new FLNP.FlutterLocalNotificationsPlugin();

                    // app_icon needs to be added as a drawable resource
                    // to the Android head project.
                    var android = new FLNP.AndroidInitializationSettings(
                        '@drawable/notification_icon');
                    var ios = new FLNP.IOSInitializationSettings();

                    // Initialize settings for both Android and iOS devices.
                    var settings = new FLNP.InitializationSettings(
                        android: android, iOS: ios);
                    flip.initialize(settings);
                    // Show a notification after every 15 minutes with the first
                    // appearance happening a minute after invoking the method
                    var androidPlatformChannelSpecifics =
                        new FLNP.AndroidNotificationDetails(
                            'NAYLORS',
                            'Naylor\'s Online',
                            'Naylor\'s Farm and Ranch Supply',
                            importance: FLNP.Importance.max,
                            priority: FLNP.Priority.high);
                    var iOSPlatformChannelSpecifics =
                        new FLNP.IOSNotificationDetails();

                    // Initialize channel platform for both Android and iOS
                    var platformChannelSpecifics = new FLNP.NotificationDetails(
                        android: androidPlatformChannelSpecifics,
                        iOS: iOSPlatformChannelSpecifics);
                    await flip.show(
                        0,
                        'Naylor\'s Farm & Ranch Supply',
                        'With but one bird you could have two stones.',
                        platformChannelSpecifics,
                        payload: 'Default_Sound');
                  })
            ]);
          }
          if (state is NavigatorLoading) {
            return Center(
                child:
                    CircularProgressIndicator(backgroundColor: Colors.white));
          }
          return Center(child: CircularProgressIndicator());
        }),
        drawer: MainNavDrawer(parent: this));
  }
}
