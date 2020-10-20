import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<AuthInfo> login(String email, String password) async {
  var body = new Map<String, dynamic>();
  body['email'] = email;
  body['password'] = password;
  final response = await http.post(
    'http://order.naylorsfeed.com/api/auth/login',
    body: body,
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var data = AuthInfo.fromJSON(json.decode(response.body));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', data.token);
    prefs.setString('email', data.email);
    prefs.setBool('isAdmin', data.isAdmin);
    return data;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to Login');
  }
}

Future<AuthInfo> register(String email, String password, String name,
    [String phone, String business, String address, String taxExempt]) async {
  var body = new Map<String, dynamic>();
  body['email'] = email;
  body['password'] = password;
  body['name'] = name;
  final response = await http.post(
    'http://order.naylorsfeed.com/api/users',
    body: body,
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var data = AuthInfo.fromJSON(json.decode(response.body));
    return data;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to Create User');
  }
}

Future<ProductList> getProducts() async {
  final response = await http.get('http://order.naylorsfeed.com/api/products');

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
  final response =
      await http.get('http://order.naylorsfeed.com/api/products/$tag');

  if (response.statusCode == 200) {
    var data = ProductDetail.fromJSON(jsonDecode(response.body));
    return data;
  } else {
    throw Exception('Failed to Get Product $tag');
  }
}

class AuthInfo {
  final String token;
  final String email;
  final bool isAdmin;

  AuthInfo({this.token, this.email, this.isAdmin});

  factory AuthInfo.fromJSON(Map<String, dynamic> json) {
    return AuthInfo(
      token: json['token'],
      email: json['email'],
      isAdmin: json['isAdmin'],
    );
  }
}

class ProductDetail {
  final String tag;
  final String name;
  final String description;
  final String category;
  final double price;
  final List images;
  final List sizes;
  final bool taxExempt;

  ProductDetail(
      {this.tag,
      this.name,
      this.description,
      this.category,
      this.price,
      this.images,
      this.sizes,
      this.taxExempt});

  factory ProductDetail.fromJSON(Map<String, dynamic> json) {
    return ProductDetail(
        tag: json['tag'].toString(),
        name: json['name'] as String,
        description: json['description'] as String,
        category: json['category'] as String,
        price: json['price'].toDouble(),
        images: json['images'],
        sizes: json['sizes'],
        taxExempt: json['taxExempt'] as bool);
  }
}

class ProductList {
  List<ProductDetail> list;

  ProductList({this.list});

  factory ProductList.fromJSON(String j) {
    Map<String, dynamic> json = jsonDecode(j);
    List<dynamic> dynamicList = json['products'] as List;
    List<ProductDetail> products = List<ProductDetail>();
    dynamicList.forEach((f) {
      ProductDetail p = ProductDetail.fromJSON(f);
      products.add(p);
    });
    return ProductList(list: products);
  }
}
