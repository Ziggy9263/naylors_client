import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:naylors_client/models/models.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
}

class OrderRequested extends OrderEvent {
  final String uuid;

  const OrderRequested({@required this.uuid}) : assert(uuid != null);

  @override
  List<Object> get props => [uuid];
}

class OrderListRequested extends OrderEvent {
  const OrderListRequested();

  @override
  List<Object> get props => [];
}

class OrderPlaced extends OrderEvent {
  final OrderReq order;

  const OrderPlaced({@required this.order}) : assert(order != null);

  @override
  List<Object> get props => [order];
}
