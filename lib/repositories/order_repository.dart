import 'package:meta/meta.dart';
import 'package:naylors_client/repositories/repositories.dart';
import 'package:naylors_client/models/models.dart';

class OrderRepository {
  final OrderApiClient orderApiClient;
  final ProductApiClient productApiClient;

  OrderRepository(
      {@required this.orderApiClient, @required this.productApiClient})
      : assert(orderApiClient != null);

  Future<OrderListRes> getOrders() async {
    return orderApiClient.fetchOrders();
  }

  Future<OrderRes> placeOrder(OrderReq order) async {
    return orderApiClient.placeOrder(order);
  }

  Future<OrderRes> cancelOrder(String uuid) async {
    return orderApiClient.deleteOrder(uuid);
  }
}
