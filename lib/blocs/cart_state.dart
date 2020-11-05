import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:naylors_client/models/models.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

/// Product (Singular)
class CartInitial extends CartState {}

class CartModificationInProgress extends CartState {}

class CartEmpty extends CartState {}

class CartNotEmpty extends CartState {
  final List<CartItem> cart;

  const CartNotEmpty({@required this.cart}) : assert(cart != null);

  @override
  List<Object> get props => [cart];
}

class CartLoadFailure extends CartState {}
