import 'package:equatable/equatable.dart';

abstract class NavigatorEvent extends Equatable {
  const NavigatorEvent();

  List<Object> get props => [];
}

class NavigatorActionPop extends NavigatorEvent {}

class NavigatorToHome extends NavigatorEvent {}

class NavigatorToProducts extends NavigatorEvent {}

class NavigatorToProduct extends NavigatorEvent {
  final int product;

  NavigatorToProduct({this.product}) : assert(product != null);

  @override
  List<Object> get props => [product];
}

class NavigatorToOrders extends NavigatorEvent {}

class NavigatorToProfile extends NavigatorEvent {}

class NavigatorToCart extends NavigatorEvent {}

class NavigatorToCheckout extends NavigatorEvent {}
