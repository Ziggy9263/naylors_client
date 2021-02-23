import 'package:meta/meta.dart';
import 'package:naylors_client/repositories/repositories.dart';
import 'package:naylors_client/models/models.dart';

class OrderRepository {
  final OrderApiClient orderApiClient;
  final ProductApiClient productApiClient;

  OrderRepository(
      {@required this.orderApiClient, @required this.productApiClient})
      : assert(orderApiClient != null);

  Future<OrderListRes> getOrders(bool admin) async {
    OrderListRes listRes = await orderApiClient.fetchOrders(admin);
    listRes.list.forEach((element) async {
      element.cartDetail = await productApiClient.populate(element.cartDetail);
    });
    return listRes;
  }

  Future<OrderRes> placeOrder(OrderReq order) async {
    OrderRes orderRes = await orderApiClient.placeOrder(order);
    orderRes.cartDetail = await productApiClient.populate(orderRes.cartDetail);
    return orderRes;
  }

  Future<OrderRes> cancelOrder(String uuid) async {
    OrderRes order = await orderApiClient.deleteOrder(uuid);
    order.cartDetail = await productApiClient.populate(order.cartDetail);
    return order;
  }
}
