import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:naylors_client/models/models.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthGet extends AuthEvent {
  const AuthGet();

  @override
  List<Object> get props => [];
}

class AuthReset extends AuthEvent {
  const AuthReset();

  @override
  List<Object> get props => [];
}

class AuthLogin extends AuthEvent {
  final AuthLoginInfo auth;
  const AuthLogin(this.auth) : assert(auth != null);

  @override
  List<Object> get props => [auth];
}

class AuthRegister extends AuthEvent {
  final AuthRegisterInfo auth;

  const AuthRegister({@required this.auth}) : assert(auth != null);

  @override
  List<Object> get props => [auth];
}
