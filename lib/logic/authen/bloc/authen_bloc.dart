import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:it_news/data/models/user.dart';
import 'package:it_news/data/repositories/account_repository.dart';
import 'package:it_news/data/store/shared_preferences.dart';

part 'authen_event.dart';
part 'authen_state.dart';

class AuthenBloc extends Bloc<AuthenEvent, AuthenState> {
  final AccountRepository _authenRepository;
  late StreamSubscription<AuthenStatus> _streamAuthenStatus;

  AuthenBloc({required AccountRepository authenRepository})
      : _authenRepository = authenRepository,
        super(const AuthenState.unknown()) {
    on<AuthenStatusChanged>(_onAuthenStatusChanged);
    on<AuthenLogoutRequested>(_onAuthenLogoutRequest);

    _streamAuthenStatus = _authenRepository.status.listen((status) async {
      add(AuthenStatusChanged(status));
    });
  }

  @override
  Future<void> close() {
    _streamAuthenStatus.cancel();
    return super.close();
  }

  void _onAuthenStatusChanged(
    AuthenStatusChanged event,
    Emitter<AuthenState> emit,
  ) async {
    switch (event.status) {
      case AuthenStatus.unauthenticated:
        return emit(const AuthenState.unauthenticated());
      case AuthenStatus.authenticated:
        int idAccount = await LocalStorage.getIdAccount();
        final user = await _authenRepository.getUser(idAccount: idAccount);
        return emit(user != null
            ? AuthenState.authenticated(user)
            : const AuthenState.unauthenticated());
      default:
        return emit(const AuthenState.unknown());
    }
  }

  void _onAuthenLogoutRequest(
      AuthenLogoutRequested event, Emitter<AuthenState> emit) {
    _authenRepository.logout();
    LocalStorage.set(key: 'logged', value: false);
  }
}
