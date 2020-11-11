import 'package:meta/meta.dart';
import 'package:naylors_client/repositories/repositories.dart';
import 'package:naylors_client/models/models.dart';

class AuthRepository {
  final AuthApiClient authApiClient;

  AuthRepository({@required this.authApiClient})
      : assert(authApiClient != null);

  Future<AuthInfo> login(String username, String password) async {
    return authApiClient.login(username, password);
  }

  Future<AuthInfo> register(AuthRegister data) async {
    return authApiClient.register(data);
  }
}