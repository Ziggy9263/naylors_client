import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import 'package:naylors_client/simple_bloc_observer.dart';
import 'package:bloc/bloc.dart';
import 'package:naylors_client/repositories/repositories.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/blocs/blocs.dart';
import 'package:naylors_client/widgets/widgets.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();

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
  );

  runApp(MyApp(
      authRepository: authRepository,
      productRepository: productRepository,
      cartRepository: cartRepository,
      orderRepository: orderRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final ProductRepository productRepository;
  final CartRepository cartRepository;
  final OrderRepository orderRepository;

  MyApp(
      {Key key,
      @required this.authRepository,
      @required this.productRepository,
      @required this.cartRepository,
      @required this.orderRepository})
      : assert(authRepository != null &&
            productRepository != null &&
            cartRepository != null &&
            orderRepository != null),
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
          '/profile': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<AuthBloc>(
                    lazy: false,
                    create: (BuildContext context) =>
                        AuthBloc(authRepository: authRepository),
                  ),
                ],
                child: ProfilePage(),
              ),
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
                  BlocProvider<AuthBloc>(
                    lazy: false,
                    create: (BuildContext context) =>
                        AuthBloc(authRepository: authRepository),
                  ),
                ],
                child: NaylorsHomePage(title: appTitle),
              ),
          '/product': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<ProductBloc>(
                    create: (context) =>
                        ProductBloc(productRepository: productRepository),
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
                ],
                child: ProductDetailBody(settings.arguments),
              ),
          '/checkout': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<CartBloc>(
                    lazy: false,
                    create: (BuildContext context) =>
                        CartBloc(cartRepository: cartRepository),
                  ),
                  BlocProvider<OrderBloc>(
                    lazy: false,
                    create: (BuildContext context) =>
                        OrderBloc(orderRepository: orderRepository),
                  ),
                  BlocProvider<AuthBloc>(
                    lazy: false,
                    create: (BuildContext context) =>
                        AuthBloc(authRepository: authRepository),
                  ),
                ],
                child: CheckoutPage(),
              ),
          '/payment': (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<CartBloc>(
                    lazy: false,
                    create: (BuildContext context) =>
                        CartBloc(cartRepository: cartRepository),
                  ),
                  BlocProvider<OrderBloc>(
                    lazy: false,
                    create: (BuildContext context) =>
                        OrderBloc(orderRepository: orderRepository),
                  ),
                  BlocProvider<AuthBloc>(
                    lazy: false,
                    create: (BuildContext context) =>
                        AuthBloc(authRepository: authRepository),
                  ),
                ],
                child: CheckoutPayment(cart: settings.arguments),
              ),
          '/orders': (context) => MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>(
                lazy: false,
                create: (BuildContext context) =>
                    AuthBloc(authRepository: authRepository),
              ),
              BlocProvider<OrderBloc>(
                lazy: false,
                create: (BuildContext context) =>
                    OrderBloc(orderRepository: orderRepository),
              ),
            ],
            child: OrderPage(),
          )
        };
        WidgetBuilder builder = routes[settings.name];
        return MaterialPageRoute(builder: (context) => builder(context));
      },
    );
  }
}
