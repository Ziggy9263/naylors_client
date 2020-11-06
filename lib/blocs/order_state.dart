import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:naylors_client/models/models.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

// Order (Placement)
class OrderPlaceInProgress extends OrderState {}

class OrderPlaceSuccess extends OrderState {
  final OrderRes order;

  const OrderPlaceSuccess({@required this.order}) : assert(order != null);

  @override
  List<Object> get props => [order];
}

class OrderPlaceFailure extends OrderState {}

/// Order (Singular)
class OrderLoadInProgress extends OrderState {}

class OrderLoadSuccess extends OrderState {
  final OrderRes order;

  const OrderLoadSuccess({@required this.order}) : assert(order != null);

  @override
  List<Object> get props => [order];
}

class OrderLoadFailure extends OrderState {}

/// Order (List)
class OrderListInitial extends OrderState {}

class OrderListLoadInProgress extends OrderState {}

class OrderListLoadSuccess extends OrderState {
  final OrderListRes orderList;

  const OrderListLoadSuccess({@required this.orderList})
      : assert(orderList != null);

  @override
  List<Object> get props => [orderList];
}

class OrderListLoadFailure extends OrderState {}
