import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:http/http.dart';
import 'package:it_news/data/repositories/account_repository.dart';
import 'package:it_news/logic/login/models/password.dart';
import 'package:it_news/logic/login/models/username.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AccountRepository _authenRepository;

  LoginBloc({required AccountRepository authenRepository})
      : _authenRepository = authenRepository,
        super(const LoginState()) {
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  @override
  Future<void> close() {
    return super.close();
  }

  void _onUsernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) {
    final username = Username.dirty(event.username);
    emit(state.copyWith(
      username: username,
      status: Formz.validate([state.password, username]),
    ));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([password, state.username]),
    ));
  }

  void _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        final Response? responseBody = await _authenRepository.login(
          username: state.username.value,
          password: state.password.value,
        );
        if (responseBody == null) {
          emit(state.copyWith(status: FormzStatus.submissionFailure));
        } else {
          if (responseBody.statusCode == 200) {
            emit(state.copyWith(status: FormzStatus.submissionSuccess));
          } else {
            emit(state.copyWith(status: FormzStatus.submissionFailure));
          }
        }
      } catch (_) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }
}
