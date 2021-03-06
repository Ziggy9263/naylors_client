import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:naylors_client/repositories/repositories.dart';
import 'package:naylors_client/models/models.dart';
import 'package:naylors_client/blocs/blocs.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({@required this.authRepository})
      : assert(authRepository != null),
        super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthReset) {
      yield AuthInitial();
    }
    if (event is AuthRetrieve) {
      yield AuthInProgress();
      try {
        final AuthInfo auth = await authRepository.getInfo();
        yield AuthSuccess(auth: auth);
      } catch (_) {
        yield AuthInitial();
      }
    }
    if (event is AuthGet) {
      yield AuthInProgress();
      try {
        final AuthInfo auth = await authRepository.getInfo();
        yield AuthSuccess(auth: auth);
      } catch (_) {
        yield AuthFailure(error: _);
      }
    }
    if (event is AuthLogin) {
      yield AuthInProgress();
      try {
        final AuthInfo auth = await authRepository.login(event.auth);
        yield AuthSuccess(auth: auth);
      } catch (_) {
        yield AuthFailure(error: _);
      }
    }
    if (event is AuthGoogle) {
      yield AuthInProgress();
      try {
        final AuthInfo auth = await authRepository.loginGoogle();
        if (auth.needsRegistration) yield AuthNeedsRegistration(auth: auth);
        else yield AuthSuccess(auth: auth);
      } catch (_) {
        yield AuthFailure(error: _);
      }
    }
    if (event is AuthRegister) {
      yield AuthInProgress();
      try {
        final AuthInfo auth = await authRepository.register(event.auth);
        yield AuthSuccess(auth: auth);
      } catch (_) {
        yield AuthFailure(error: _);
      }
    }
    if (event is AuthLogout) {
      authRepository.logout();
      yield AuthInitial();
    }
  }

  String get email => authRepository.email;
  bool get isAdmin => authRepository.isAdmin;
}
