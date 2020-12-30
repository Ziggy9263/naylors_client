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
  FloatingActionButton floatingButton;

  @override
  Stream<NaylorsNavigatorState> mapEventToState(NavigatorEvent event) async* {
    if (event is NavigatorActionPop) {
      navigatorKey.currentState.pop();
    }
    if (event is NavigatorToHome) {
      appBarToggle = true;
      cartToggle = false;
      searchToggle = false;
      floatingButton = null;
    }
    if (event is NavigatorToProducts) {
      yield NavigatorLoading();
      appBarToggle = true;
      cartToggle = false;
      searchToggle = false;
      floatingButton = null;
      yield NavigatorAtProducts();
    }
    if (event is NavigatorToCategories) {
      yield NavigatorLoading();
      appBarToggle = true;
      cartToggle = false;
      searchToggle = false;
      floatingButton = null;
      yield NavigatorAtCategories();
    }
    if (event is NavigatorToProduct) {
      yield NavigatorLoading();
      appBarToggle = true;
      cartToggle = false;
      searchToggle = false;
      floatingButton = null;
      yield NavigatorAtProduct(product: event.product);
    }
    if (event is NavigatorToProductEdit) {
      yield NavigatorLoading();
      appBarToggle = true;
      cartToggle = false;
      searchToggle = false;
      floatingButton = null;
      yield NavigatorAtProductEdit(product: event.product);
    }
    if (event is NavigatorToOrders) {
      yield NavigatorLoading();
      appBarToggle = true;
      cartToggle = false;
      searchToggle = false;
      floatingButton = null;
      yield NavigatorAtOrders();
    }
    if (event is NavigatorToProfile) {
      yield NavigatorLoading();
      appBarToggle = true;
      cartToggle = false;
      searchToggle = false;
      floatingButton = null;
      yield NavigatorAtProfile();
    }
    if (event is NavigatorToCart) {
      yield NavigatorLoading();
      appBarToggle = true;
      searchToggle = false;
      floatingButton = null;
      cartToggle = !cartToggle;
      if (cartToggle)
        yield NavigatorAtCart();
      else
        yield NavigatorAtProducts();
    }
    if (event is NavigatorToCheckout) {
      yield NavigatorLoading();
      appBarToggle = false;
      cartToggle = false;
      searchToggle = false;
      floatingButton = null;
      yield NavigatorAtCheckout();
    }
    if (event is NavigatorToPayment) {
      yield NavigatorLoading();
      appBarToggle = false;
      floatingButton = null;
      yield NavigatorAtPayment(payOption: event.payOption);
    }
    if (event is NavigatorToSearch) {
      yield NavigatorLoading();
      appBarToggle = true;
      cartToggle = false;
      floatingButton = null;
      searchToggle = !searchToggle;
      if (searchToggle)
        yield NavigatorAtSearch();
      else
        yield NavigatorAtProducts();
    }
    if (event is NavigatorToDebug) {
      yield NavigatorLoading();
      appBarToggle = true;
      cartToggle = false;
      searchToggle = false;
      floatingButton = null;
      yield NavigatorAtDebug();
    }
  }
}
