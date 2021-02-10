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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var body = new Map<String, dynamic>();
    body['email'] = data.email;
    body['name'] = data.name;
    body['phone'] = data.phone;
    if (data.business != "") body['business'] = data.business;
    if (data.address != "") body['address'] = data.address;
    if (data.addrState != "") body['state'] = data.addrState;
    if (data.addrZip != "") body['zipcode'] = data.addrZip;
    final response = await this.httpClient.post('$baseUrl/api/users',
        body: body, headers: {'Authorization': 'Bearer $token'});

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

  Future<AuthInfo> googleLoginAuthentication(AuthInfo auth) async {
    var headers = new Map<String, String>();
    headers['Content-Type'] = 'application/json';
    headers['Authorization'] = 'Bearer ${auth.token}';
    final response =
        await this.httpClient.get('$baseUrl/api/auth', headers: headers);

    if (response.statusCode == 200) {
      var dbResponse = AuthInfo.fromJSON(json.decode(response.body));
      var data = new AuthInfo(
          email: dbResponse.email,
          token: auth.token,
          isAdmin: dbResponse.isAdmin,
          needsRegistration: false);
      return data;
    } else if (response.statusCode == 404) {
      var data = new AuthInfo(
          email: auth.email,
          token: auth.token,
          isAdmin: auth.isAdmin,
          needsRegistration: true);
      return data;
    } else {
      throw Exception('Something went wrong.');
    }
  }
}
