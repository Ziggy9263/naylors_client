import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:naylors_client/models/models.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthInProgress extends AuthState {}

class AuthSuccess extends AuthState {
  final AuthInfo auth;

  const AuthSuccess({@required this.auth}) : assert(auth != null);

  @override
  List<Object> get props => [auth];
}

class AuthNeedsRegistration extends AuthState {
  final AuthInfo auth;

  const AuthNeedsRegistration({@required this.auth}) : assert(auth != null);

  @override
  List<Object> get props => [auth];
}

class AuthRegisterSuccess extends AuthState {
  final AuthInfo auth;

  const AuthRegisterSuccess({@required this.auth}) : assert(auth != null);

  @override
  List<Object> get props => [auth];
}

class AuthFailure extends AuthState {
  final dynamic error;

  const AuthFailure({@required this.error}) : assert(error != null);

  @override
  List<Object> get props => [error];
}
