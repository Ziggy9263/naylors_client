import 'dart:async';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:naylors_client/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderApiClient {
  static const baseUrl = 'https://order.naylorsfeed.com';
  final http.Client httpClient;

  OrderApiClient({@required this.httpClient}) : assert(httpClient != null);

  Future<OrderRes> placeOrder(OrderReq order) async {
    var body = new Map<String, dynamic>();
    body['cartDetail'] = order.cartDetail
        .map((d) => {'product': d.product, 'quantity': d.quantity})
        .toList();
    body['userComments'] = order.userComments;
    body['paymentInfo'] = {
      'cardNumber': order.paymentInfo.cardNumber,
      'expiryMonth': order.paymentInfo.expiryMonth,
      'expiryYear': order.paymentInfo.expiryYear,
      'cvv': order.paymentInfo.cvv,
      'avsZip': order.paymentInfo.avsZip,
      'avsStreet': order.paymentInfo.avsStreet
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    final response = await this.httpClient.post(
      '$baseUrl/api/orders',
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var res = OrderRes.fromJSON(json.decode(response.body));
      return res;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          'Status ${response.statusCode} ${response.reasonPhrase}: ${response.body}');
    }
  }

  Future<OrderListRes> fetchOrders() async {
    final ordersUrl = "$baseUrl/api/orders/";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    final response = await this.httpClient.get(
      ordersUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

    if (response.statusCode == 200) {
      if (response.body == '[]') {
        return OrderListRes(list: []);
      }
      var data = OrderListRes.fromJSON(jsonDecode(response.body));
      return data;
    } else {
      throw Exception('Failed to Get List of Orders');
    }
  }
}
