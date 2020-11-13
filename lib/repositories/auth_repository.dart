import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:naylors_client/repositories/repositories.dart';
import 'package:naylors_client/models/models.dart';

class AuthRepository {
  final AuthApiClient authApiClient;
  AuthInfo auth = new AuthInfo(token: '', email: '', isAdmin: false);

  AuthRepository({@required this.authApiClient})
      : assert(authApiClient != null);

  Future<AuthInfo> login(AuthLoginInfo data) async {
    auth = await authApiClient.login(data);
    return auth;
  }

  Future<AuthInfo> register(AuthRegisterInfo data) async {
    auth = await authApiClient.register(data);
    return auth;
  }

  Future<AuthInfo> getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    auth = new AuthInfo(
        token: prefs.getString('token') ?? null,
        email: prefs.getString('email') ?? null,
        isAdmin: prefs.getBool('isAdmin') ?? false);
    if (auth.token == null || auth.email == null) {
      throw Exception("$auth is incorrect");
    }
    return auth;
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  String get email {
    return this.auth.email ?? "Not Available";
  }
}
