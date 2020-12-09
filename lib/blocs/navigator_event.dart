import 'package:equatable/equatable.dart';
import 'package:naylors_client/models/models.dart';

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

class NavigatorToProductEdit extends NavigatorEvent {
  final int product;
  NavigatorToProductEdit({this.product});

  @override
  List<Object> get props => [product];
}

class NavigatorToOrders extends NavigatorEvent {}

class NavigatorToProfile extends NavigatorEvent {}

class NavigatorToCart extends NavigatorEvent {}

class NavigatorToCheckout extends NavigatorEvent {}

class NavigatorToPayment extends NavigatorEvent {
  final PayOption payOption;
  NavigatorToPayment({this.payOption}) : assert(payOption != null);

  @override
  List<Object> get props => [payOption];
}

class NavigatorToSearch extends NavigatorEvent {}

class NavigatorToDebug extends NavigatorEvent {}
