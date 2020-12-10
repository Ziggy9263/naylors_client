import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

import 'package:naylors_client/simple_bloc_observer.dart';
import 'package:bloc/bloc.dart';
import 'package:naylors_client/repositories/repositories.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/widgets/widgets.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  
  Workmanager.initialize(
    // Top level function, aka callbackDispatcher
    callbackDispatcher,
    // If enabled will post a notification whenever task is running
    // Handy for debugging tasks
    isInDebugMode: true,
  );
  // Periodic task registration
  Workmanager.registerPeriodicTask(
    "2",
    // This is the value that will be returned in the callbackDispatcher
    "simplePeriodicTask",
    // When no frequency is provided, the default 15 minutes is set.
    // Minimum frequency is 15 minutes. Android will automatically change your
    // frequency to 15 minutes if you have configured a lower frequency.
    frequency: Duration(minutes: 30),
    initialDelay: Duration(minutes: -30),
  );

  final AuthRepository authRepository = AuthRepository(
    authApiClient: AuthApiClient(
      httpClient: http.Client(),
    ),
  );

  final ProductRepository productRepository = ProductRepository(
    productApiClient: ProductApiClient(
      httpClient: http.Client(),
    ),
  );

  final CartRepository cartRepository = CartRepository(
    detail: List<CartItem>(),
  );

  final OrderRepository orderRepository = OrderRepository(
    orderApiClient: OrderApiClient(
      httpClient: http.Client(),
    ),
    productApiClient: productRepository.productApiClient,
  );

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  runApp(MyApp(
      authRepository: authRepository,
      productRepository: productRepository,
      cartRepository: cartRepository,
      orderRepository: orderRepository,
      navigatorKey: navigatorKey));
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) {
    // Initialize the plugin of flutterlocalnotifications
    FlutterLocalNotificationsPlugin flip =
        new FlutterLocalNotificationsPlugin();

    // app_icon needs to be added as a drawable resource
    // to the Android head project.
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();

    // Initialize settings for both Android and iOS devices.
    var settings = new InitializationSettings(android: android, iOS: ios);
    flip.initialize(settings);
    _showNotificationWithDefaultSound(flip);
    return Future.value(true);
  });
}

Future _showNotificationWithDefaultSound(FlutterLocalNotificationsPlugin flip) async {
  // Show a notification after every 15 minutes with the first
  // appearance happening a minute after invoking the method
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'NAYLORS', 'Naylor\'s Online', 'Naylor\'s Farm and Ranch Supply',
      importance: Importance.max, priority: Priority.high);
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

  // Initialize channel platform for both Android and iOS
  var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
  await flip.show(0, 'Naylor\'s Farm & Ranch Supply',
      'The early worm catches a big bird!', platformChannelSpecifics,
      payload: 'Default_Sound');
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final ProductRepository productRepository;
  final CartRepository cartRepository;
  final OrderRepository orderRepository;
  final GlobalKey<NavigatorState> navigatorKey;

  MyApp(
      {Key key,
      @required this.authRepository,
      @required this.productRepository,
      @required this.cartRepository,
      @required this.orderRepository,
      @required this.navigatorKey})
      : assert(authRepository != null &&
            productRepository != null &&
            cartRepository != null &&
            orderRepository != null &&
            navigatorKey != null),
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
      initialRoute: '/login',
      onGenerateRoute: (RouteSettings settings) {
        var routes = <String, WidgetBuilder>{
          '/login': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<AuthBloc>(
                    lazy: false,
                    create: (BuildContext context) =>
                        AuthBloc(authRepository: authRepository),
                  ),
                ],
                child: LoginPage(),
              ),
          '/register': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<AuthBloc>(
                    lazy: false,
                    create: (BuildContext context) =>
                        AuthBloc(authRepository: authRepository),
                  ),
                ],
                child: RegisterPage(),
              ),
          '/': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<ProductBloc>(
                    create: (BuildContext context) =>
                        ProductBloc(productRepository: productRepository),
                  ),
                  BlocProvider<ProductListBloc>(
                    create: (BuildContext context) =>
                        ProductListBloc(productRepository: productRepository),
                  ),
                  BlocProvider<CartBloc>(
                    lazy: false,
                    create: (BuildContext context) =>
                        CartBloc(cartRepository: cartRepository),
                  ),
                  BlocProvider<AuthBloc>(
                    lazy: false,
                    create: (BuildContext context) =>
                        AuthBloc(authRepository: authRepository),
                  ),
                  BlocProvider<NavigatorBloc>(
                    lazy: false,
                    create: (BuildContext context) =>
                        NavigatorBloc(navigatorKey: navigatorKey),
                  ),
                  BlocProvider<OrderBloc>(
                    lazy: false,
                    create: (BuildContext context) =>
                        OrderBloc(orderRepository: orderRepository),
                  ),
                  BlocProvider<OrderListBloc>(
                    lazy: false,
                    create: (BuildContext context) => OrderListBloc(
                        orderRepository: orderRepository,
                        productRepository: productRepository),
                  ),
                  BlocProvider<SearchBloc>(
                    lazy: false,
                    create: (BuildContext context) =>
                        SearchBloc(productRepository: productRepository),
                  ),
                ],
                child: NaylorsHomePage(
                    title: appTitle, scaffoldKey: GlobalKey<ScaffoldState>()),
              ),
        };
        WidgetBuilder builder = routes[settings.name];
        return MaterialPageRoute(builder: (context) => builder(context));
      },
    );
  }
}
