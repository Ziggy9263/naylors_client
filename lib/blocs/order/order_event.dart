import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:naylors_client/models/models.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
}

class OrderReset extends OrderEvent {
  const OrderReset();

  @override
  List<Object> get props => [];
}

class OrderRequested extends OrderEvent {
  final String uuid;

  const OrderRequested({@required this.uuid}) : assert(uuid != null);

  @override
  List<Object> get props => [uuid];
}

class OrderPlaced extends OrderEvent {
  final OrderReq order;

  const OrderPlaced({@required this.order}) : assert(order != null);

  @override
  List<Object> get props => [order];
}

class OrderCancel extends OrderEvent {
  final String uuid;

  const OrderCancel({@required this.uuid}) : assert(uuid != null);

  @override
  List<Object> get props => [uuid];
}

abstract class OrderListEvent extends Equatable {
  const OrderListEvent();
}

class OrderListRequested extends OrderListEvent {
  final int choice;
  final bool admin;
  const OrderListRequested({this.choice = 0, this.admin = false});

  @override
  List<Object> get props => [choice, admin];
}
