import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import 'package:naylors_client/login.dart';
import 'package:naylors_client/register.dart';
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

  runApp(MyApp(
      productRepository: productRepository, cartRepository: cartRepository));
}

class MyApp extends StatelessWidget {
  final ProductRepository productRepository;
  final CartRepository cartRepository;

  MyApp(
      {Key key,
      @required this.productRepository,
      @required this.cartRepository})
      : assert(productRepository != null),
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
      initialRoute: '/', // Skipping login for now TODO: Don't forget to revert
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
            ],
            child: CheckoutPage(),
          ),
        };
        WidgetBuilder builder = routes[settings.name];
        return MaterialPageRoute(builder: (context) => builder(context));
      },
    );
  }
}