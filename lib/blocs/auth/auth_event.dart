import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:naylors_client/models/models.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

/// Retrieve auth data, if it already exists
class AuthRetrieve extends AuthEvent {
  const AuthRetrieve();

  @override
  List<Object> get props => [];
}

/// Get auth data, which should exist already
class AuthGet extends AuthEvent {
  const AuthGet();

  @override
  List<Object> get props => [];
}

/// Reset auth (for handling errors)
class AuthReset extends AuthEvent {
  const AuthReset();

  @override
  List<Object> get props => [];
}

/// Send login data
class AuthLogin extends AuthEvent {
  final AuthLoginInfo auth;
  const AuthLogin(this.auth) : assert(auth != null);

  @override
  List<Object> get props => [auth];
}

/// Send register data
class AuthRegister extends AuthEvent {
  final AuthRegisterInfo auth;

  const AuthRegister({@required this.auth}) : assert(auth != null);

  @override
  List<Object> get props => [auth];
}

/// Clear local auth data
class AuthLogout extends AuthEvent {
  const AuthLogout();

  @override
  List<Object> get props => [];
}
