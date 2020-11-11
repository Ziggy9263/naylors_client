import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:naylors_client/models/models.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthLogin extends AuthEvent {
  final String username;
  final String password;
  const AuthLogin(this.username, this.password) : assert(username != null && password != null);

  @override
  List<Object> get props => [username, password];
}

class AuthRegister extends AuthEvent {
  final AuthRegisterInfo auth;

  const AuthRegister({@required this.auth}) : assert(auth != null);

  @override
  List<Object> get props => [auth];
}
