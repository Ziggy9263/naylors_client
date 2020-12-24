import 'dart:async';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:naylors_client/models/models.dart';

class ProductApiClient {
  static const baseUrl = 'https://order.naylorsfeed.com';
  final http.Client httpClient;

  ProductApiClient({@required this.httpClient}) : assert(httpClient != null);

  Future<ProductList> fetchProducts() async {
    final productsUrl = "$baseUrl/api/products";
    final response = await this.httpClient.get(productsUrl);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = ProductList.fromJSON(response.body);
      return data;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to Get Products');
    }
  }

  Future<ProductList> fetchByCategory(Category category) async {
    final productsUrl = "$baseUrl/api/products/?q=${category.id}";
    final response = await this.httpClient.get(productsUrl);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = ProductList.fromJSON(response.body);
      return data;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to Get Products');
    }
  }

  Future<ProductDetail> getProduct(String tag) async {
    final productUrl = "$baseUrl/api/products/$tag";
    final response = await this.httpClient.get(productUrl);

    if (response.statusCode == 200) {
      var data = ProductDetail.fromJSON(jsonDecode(response.body));
      return data;
    } else {
      throw Exception('Failed to Get Product $tag');
    }
  }

  Future<ProductList> searchProducts(String query) async {
    final productUrl = "$baseUrl/api/products/?q=$query";
    final response = await this.httpClient.get(productUrl);

    if (response.statusCode == 200) {
      var data = ProductList.fromJSON(response.body);
      return data;
    } else {
      throw Exception('Search for $query failed!');
    }
  }

  Future<List<CartItem>> populate(List<CartItem> detail) async {
    for (int index = 0; index < detail.length; index++) {
      if (detail[index].detail == null) {
        detail[index].detail =
            await this.getProduct(detail[index].product.toString());
      }
    }
    return detail;
  }
}
