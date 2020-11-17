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

  @override
  Stream<NaylorsNavigatorState> mapEventToState(NavigatorEvent event) async* {
    if (event is NavigatorActionPop) {
      navigatorKey.currentState.pop();
    }
    if (event is NavigatorToHome) {
      navigatorKey.currentState.pushReplacementNamed('/');
    }
    if (event is NavigatorToProducts) {
      yield NavigatorAtProducts();
    }
    if (event is NavigatorToProduct) {
      navigatorKey.currentState.pushNamed('/product', arguments: event.product);
      yield NavigatorAtProduct(product: event.product);
    }
    if (event is NavigatorToOrders) {
      yield NavigatorAtOrders();
    }
    if (event is NavigatorToProfile) {
      yield NavigatorAtProfile();
    }
    if (event is NavigatorToCart) {
      navigatorKey.currentState.pushNamed('/cart');
      yield NavigatorAtCart();
    }
    if (event is NavigatorToCheckout) {
      navigatorKey.currentState.pushNamed('/checkout');
      yield NavigatorAtCheckout();
    }
  }
}
