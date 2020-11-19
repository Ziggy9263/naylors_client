import 'dart:async';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:naylors_client/models/models.dart';

class AuthApiClient {
  static const baseUrl = 'https://order.naylorsfeed.com';
  final http.Client httpClient;

  AuthApiClient({@required this.httpClient}) : assert(httpClient != null);

  Future<AuthInfo> login(AuthLoginInfo auth) async {
    var body = new Map<String, dynamic>();
    body['email'] = auth.email;
    body['password'] = auth.password;
    final response = await this.httpClient.post(
          '$baseUrl/api/auth/login',
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

  Future<AuthInfo> register(AuthRegisterInfo data) async {
    var body = new Map<String, dynamic>();
    body['email'] = data.email;
    body['password'] = data.password;
    body['name'] = data.name;
    final response = await this.httpClient.post(
      '$baseUrl/api/users',
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
      throw Exception('Something went wrong!');
    }
  }
}
