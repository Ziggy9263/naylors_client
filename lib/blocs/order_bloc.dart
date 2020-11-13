import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:naylors_client/repositories/repositories.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/blocs/blocs.dart';

String formatError(dynamic error) {
  String formatted = error.toString();
  formatted = formatted.replaceAll(new RegExp(r'\\n'), '  \n');
  formatted = formatted.replaceAll(new RegExp(r'&quot;'), "'");
  formatted = formatted.replaceAll(new RegExp(r'    '), ">");
  print('FORMATTED ERROR: $formatted');
  return 'Error Dump: \n\n>$formatted';
}

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;

  OrderBloc({@required this.orderRepository})
      : assert(orderRepository != null),
        super(OrderInitial());

  @override
  Stream<OrderState> mapEventToState(OrderEvent event) async* {
    if (event is OrderReset) {
      yield OrderInitial();
    }
    if (event is OrderPlaced) {
      yield OrderPlaceInProgress();
      try {
        final OrderRes order = await orderRepository.placeOrder(event.order);
        yield OrderPlaceSuccess(order: order);
      } catch (_) {
        yield OrderPlaceFailure(error: _, formatted: formatError(_));
      }
    }
    if (event is OrderListRequested) {
      yield OrderListLoadInProgress();
      try {
        final OrderListRes orderList = await orderRepository.getOrders();
        yield OrderListLoadSuccess(orderList: orderList);
      } catch (_) {
        yield OrderListLoadFailure(error: _);
      }
    }
  }
}

/*class OrderListBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;

  OrderListBloc({@required this.orderRepository})
      : assert(orderRepository != null),
        super(OrderListInitial());

  @override
  Stream<OrderState> mapEventToState(OrderEvent event) async* {
    if (event is OrderListRequested) {
      yield OrderListLoadInProgress();
      try {
        final OrderListRes orderList = await orderRepository.getOrders();
        yield OrderListLoadSuccess(orderList: orderList);
      } catch (_) {
        yield OrderListLoadFailure();
      }
    }
  }
}
*/
