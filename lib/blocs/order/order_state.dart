import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:naylors_client/models/models.dart';

/// Order
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

class OrderPlaceFailure extends OrderState {
  final dynamic error;
  final String formatted;

  const OrderPlaceFailure({@required this.error, @required this.formatted})
      : assert(error != null && formatted != null);

  @override
  List<Object> get props => [error, formatted];
}

/// Order (Cancellation)
class OrderCancelInProgress extends OrderState {}

class OrderCancelSuccess extends OrderState {
  final OrderRes order;

  const OrderCancelSuccess({@required this.order}) : assert(order != null);

  @override
  List<Object> get props => [order];
}

class OrderCancelFailure extends OrderState {
  final dynamic error;
  final String formatted;

  const OrderCancelFailure({@required this.error, @required this.formatted})
      : assert(error != null && formatted != null);

  @override
  List<Object> get props => [error, formatted];
}

/// Order (Load)
class OrderLoadInProgress extends OrderState {}

class OrderLoadSuccess extends OrderState {
  final OrderRes order;

  const OrderLoadSuccess({@required this.order}) : assert(order != null);

  @override
  List<Object> get props => [order];
}

class OrderLoadFailure extends OrderState {}

/// OrderList
abstract class OrderListState extends Equatable {
  const OrderListState();

  @override
  List<Object> get props => [];
}

class OrderListInitial extends OrderListState {}

class OrderListEmpty extends OrderListState {}

class OrderListLoadInProgress extends OrderListState {}

class OrderListLoadSuccess extends OrderListState {
  final OrderListRes orderList;

  const OrderListLoadSuccess({@required this.orderList})
      : assert(orderList != null);

  @override
  List<Object> get props => [orderList];
}

class OrderListLoadFailure extends OrderListState {
  final dynamic error;

  const OrderListLoadFailure({@required this.error}) : assert(error != null);

  @override
  List<Object> get props => [error];
}
