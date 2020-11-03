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