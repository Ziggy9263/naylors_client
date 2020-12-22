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

  bool appBarToggle = true;
  bool cartToggle = false;
  bool searchToggle = false;

  @override
  Stream<NaylorsNavigatorState> mapEventToState(NavigatorEvent event) async* {
    if (event is NavigatorActionPop) {
      navigatorKey.currentState.pop();
    }
    if (event is NavigatorToHome) {
      appBarToggle = true;
      cartToggle = false;
      searchToggle = false;
    }
    if (event is NavigatorToProducts) {
      appBarToggle = true;
      cartToggle = false;
      searchToggle = false;
      yield NavigatorAtProducts();
    }
    if (event is NavigatorToCategories) {
      appBarToggle = true;
      cartToggle = false;
      searchToggle = false;
      yield NavigatorAtCategories();
    }
    if (event is NavigatorToProduct) {
      appBarToggle = true;
      cartToggle = false;
      searchToggle = false;
      yield NavigatorAtProduct(product: event.product);
    }
    if (event is NavigatorToProductEdit) {
      appBarToggle = true;
      cartToggle = false;
      searchToggle = false;
      yield NavigatorAtProductEdit(product: event.product);
    }
    if (event is NavigatorToOrders) {
      appBarToggle = true;
      cartToggle = false;
      searchToggle = false;
      yield NavigatorAtOrders();
    }
    if (event is NavigatorToProfile) {
      appBarToggle = true;
      cartToggle = false;
      searchToggle = false;
      yield NavigatorAtProfile();
    }
    if (event is NavigatorToCart) {
      appBarToggle = true;
      searchToggle = false;
      cartToggle = !cartToggle;
      if (cartToggle)
        yield NavigatorAtCart();
      else
        yield NavigatorAtProducts();
    }
    if (event is NavigatorToCheckout) {
      appBarToggle = false;
      cartToggle = false;
      searchToggle = false;
      yield NavigatorAtCheckout();
    }
    if (event is NavigatorToPayment) {
      appBarToggle = false;
      yield NavigatorAtPayment(payOption: event.payOption);
    }
    if (event is NavigatorToSearch) {
      appBarToggle = true;
      cartToggle = false;
      searchToggle = !searchToggle;
      if (searchToggle)
        yield NavigatorAtSearch();
      else
        yield NavigatorAtProducts();
    }
    if (event is NavigatorToDebug) {
      appBarToggle = true;
      cartToggle = false;
      searchToggle = false;
      yield NavigatorAtDebug();
    }
  }
}
