import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
}

class CartModify extends CartEvent {
  final int product;
  final int quantity;

  const CartModify({@required this.product, @required this.quantity})
      : assert(product != null && quantity != null);

  @override
  List<Object> get props => [product, quantity];
}

class CartRemove extends CartEvent {
  final int product;

  const CartRemove({@required this.product}) : assert(product != null);

  @override
  List<Object> get props => [product];
}

class CartRequested extends CartEvent {
  @override
  List<Object> get props => [];
}

class CartClear extends CartEvent {
  @override
  List<Object> get props => [];
}
