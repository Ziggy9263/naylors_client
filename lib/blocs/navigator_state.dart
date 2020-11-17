import 'package:equatable/equatable.dart';

abstract class NaylorsNavigatorState extends Equatable {
  const NaylorsNavigatorState();

  @override
  List<Object> get props => [];
}

class NavigatorInitial extends NaylorsNavigatorState {}

class NavigatorAtHome extends NaylorsNavigatorState {}

class NavigatorAtProducts extends NaylorsNavigatorState {}

class NavigatorAtProduct extends NaylorsNavigatorState {
  final int product;

  NavigatorAtProduct({this.product}) : assert(product != null);

  @override
  List<Object> get props => [product];
}

class NavigatorAtOrders extends NaylorsNavigatorState {}

class NavigatorAtProfile extends NaylorsNavigatorState {}

class NavigatorAtCart extends NaylorsNavigatorState {}

class NavigatorAtCheckout extends NaylorsNavigatorState {}
