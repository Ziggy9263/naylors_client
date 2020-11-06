import 'package:meta/meta.dart';
import 'package:naylors_client/repositories/repositories.dart';
import 'package:naylors_client/models/models.dart';

class OrderRepository {
  final OrderApiClient orderApiClient;

  OrderRepository({@required this.orderApiClient})
      : assert(orderApiClient != null);

  Future<OrderListRes> getOrders() async {
    return orderApiClient.fetchOrders();
  }

  Future<OrderRes> placeOrder(OrderReq order) async {
    return orderApiClient.placeOrder(order);
  }
}
