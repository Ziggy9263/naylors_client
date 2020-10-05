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
