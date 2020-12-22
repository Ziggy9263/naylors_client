import 'dart:async';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:naylors_client/models/models.dart';

class CategoryApiClient {
  static const baseUrl = 'https://order.naylorsfeed.com';
  final http.Client httpClient;

  CategoryApiClient({@required this.httpClient}) : assert(httpClient != null);

  Future<CategoryList> fetchCategories() async {
    final categoriesUrl = "$baseUrl/api/categories";
    final response = await this.httpClient.get(categoriesUrl);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = CategoryList.fromJSON(response.body);
      return data;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to Get Categories');
    }
  }

  Future<Category> getCategory(String id) async {
    final categoryUrl = "$baseUrl/api/categories/$id";
    final response = await this.httpClient.get(categoryUrl);

    if (response.statusCode == 200) {
      var data = Category.fromJSON(jsonDecode(response.body));
      return data;
    } else {
      throw Exception('Failed to Get Category $id');
    }
  }

  Future<CategoryList> searchCategories(String query) async {
    final categoryUrl = "$baseUrl/api/categories/?q=$query";
    final response = await this.httpClient.get(categoryUrl);

    if (response.statusCode == 200) {
      var data = CategoryList.fromJSON(response.body);
      return data;
    } else {
      throw Exception('Search for $query failed!');
    }
  }
}
