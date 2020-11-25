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

class OrderPlaceFailure extends OrderState {
  final dynamic error;
  final String formatted;

  const OrderPlaceFailure({@required this.error, @required this.formatted})
      : assert(error != null && formatted != null);

  @override
  List<Object> get props => [error, formatted];
}

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

class OrderListEmpty extends OrderState {}

class OrderListLoadFailure extends OrderState {
  final dynamic error;

  const OrderListLoadFailure({@required this.error}) : assert(error != null);

  @override
  List<Object> get props => [error];
}
