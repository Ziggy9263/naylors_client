import 'dart:async';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:naylors_client/models/models.dart';

class OrderApiClient {
  static const baseUrl = 'http://order.naylorsfeed.com';
  final http.Client httpClient;

  OrderApiClient({@required this.httpClient}) : assert(httpClient != null);

  
  Future<OrderRes> placeOrder(OrderReq order) async {
    var body = new Map<String, dynamic>();
    body['cartDetail'] = order.cartDetail;
    body['userComments'] = order.userComments;
    body['paymentInfo'] = order.paymentInfo;
    final response = await http.post(
      'http://order.naylorsfeed.com/api/orders',
      body: body,
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var res = OrderRes.fromJSON(json.decode(response.body));
      return res;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to Create User');
    }
  }

  Future<OrderListRes> fetchOrders() async {
    final ordersUrl = "$baseUrl/api/orders/";
    final response =
        await this.httpClient.get(ordersUrl);

    if (response.statusCode == 200) {
      var data = OrderListRes.fromJSON(jsonDecode(response.body));
      return data;
    } else {
      throw Exception('Failed to Get List of Orders');
    }
  }
}
