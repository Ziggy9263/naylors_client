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
    if (event is AuthLogin) {
      yield AuthInProgress();
      try {
        final AuthInfo auth = await authRepository.login(event.username, event.password);
        yield AuthSuccess(auth: auth);
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
  }
}
