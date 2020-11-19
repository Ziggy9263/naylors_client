import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

import 'package:naylors_client/repositories/repositories.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/blocs/blocs.dart';

class NavigatorBloc extends Bloc<NavigatorEvent, NaylorsNavigatorState> {
  final GlobalKey<NavigatorState> navigatorKey;

  NavigatorBloc({@required this.navigatorKey})
      : assert(navigatorKey != null),
        super(NavigatorInitial());

  bool cartToggle = false;

  @override
  Stream<NaylorsNavigatorState> mapEventToState(NavigatorEvent event) async* {
    if (event is NavigatorActionPop) {
      navigatorKey.currentState.pop();
    }
    if (event is NavigatorToHome) {
      cartToggle = false;
      navigatorKey.currentState.pushReplacementNamed('/');
    }
    if (event is NavigatorToProducts) {
      cartToggle = false;
      yield NavigatorAtProducts();
    }
    if (event is NavigatorToProduct) {
      cartToggle = false;
      navigatorKey.currentState.pushNamed('/product', arguments: event.product);
      yield NavigatorAtProduct(product: event.product);
    }
    if (event is NavigatorToOrders) {
      cartToggle = false;
      yield NavigatorAtOrders();
    }
    if (event is NavigatorToProfile) {
      cartToggle = false;
      yield NavigatorAtProfile();
    }
    if (event is NavigatorToCart) {
      cartToggle = !cartToggle;
      if (cartToggle)
        yield NavigatorAtCart();
      else
        yield NavigatorAtProducts();
    }
    if (event is NavigatorToCheckout) {
      cartToggle = false;
      navigatorKey.currentState.pushNamed('/checkout');
      yield NavigatorAtCheckout();
    }
  }
}
