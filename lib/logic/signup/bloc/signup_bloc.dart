import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:http/http.dart';
import 'package:it_news/data/repositories/account_repository.dart';
import 'package:it_news/logic/login/models/password.dart';
import 'package:it_news/logic/signup/models/account_name.dart';
import 'package:it_news/logic/signup/models/confirm_password.dart';
import 'package:it_news/logic/signup/models/email.dart';
import 'package:it_news/logic/signup/models/real_name.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AccountRepository _accountRepository;

  SignupBloc({required AccountRepository accountRepository})
      : _accountRepository = accountRepository,
        super(const SignupState()) {
    on<SignupAccountNameChanged>(_onAccountNameChanged);
    on<SignupRealNameChanged>(_onRealNameChanged);
    on<SignupEmailChanged>(_onEmailNameChanged);
    on<SignupPasswordChanged>(_onPasswordChanged);
    on<SignupConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<SignupSubmitted>(_onSubmitted);
  }

  void _onAccountNameChanged(
      SignupAccountNameChanged event, Emitter<SignupState> emit) {
    final accountName = AccountName.dirty(event.accountName);
    emit(state.copyWith(
      accountName: accountName,
      status: Formz.validate([
        accountName,
        state.realName,
        state.email,
        state.password,
        state.confirmPassword
      ]),
    ));
  }

  void _onRealNameChanged(
      SignupRealNameChanged event, Emitter<SignupState> emit) {
    final realName = RealName.dirty(event.realName);
    emit(state.copyWith(
      realName: realName,
      status: Formz.validate([
        realName,
        state.accountName,
        state.email,
        state.password,
        state.confirmPassword
      ]),
    ));
  }

  void _onEmailNameChanged(
      SignupEmailChanged event, Emitter<SignupState> emit) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([
        email,
        state.accountName,
        state.realName,
        state.password,
        state.confirmPassword
      ]),
    ));
  }

  void _onPasswordChanged(
      SignupPasswordChanged event, Emitter<SignupState> emit) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([
        password,
        state.accountName,
        state.realName,
        state.email,
        state.confirmPassword,
      ]),
    ));

    final confirmPassword = ConfirmPassword.dirty(
        [state.confirmPassword.value![0], event.password]);
    emit(state.copyWith(
      confirmPassword: confirmPassword,
      status: Formz.validate([
        confirmPassword,
        state.accountName,
        state.realName,
        state.email,
        state.password,
      ]),
    ));
  }

  void _onConfirmPasswordChanged(
      SignupConfirmPasswordChanged event, Emitter<SignupState> emit) {
    final confirmPassword =
        ConfirmPassword.dirty([event.confirmPassword, state.password.value]);
    emit(state.copyWith(
      confirmPassword: confirmPassword,
      status: Formz.validate([
        confirmPassword,
        state.accountName,
        state.realName,
        state.email,
        state.password,
      ]),
    ));
  }

  void _onSubmitted(SignupSubmitted event, Emitter<SignupState> emit) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));

      final Response? response = await _accountRepository.signup(
        accountName: state.accountName.value,
        realName: state.realName.value,
        email: state.email.value,
        password: state.password.value,
      );

      if (response == null) {
        emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            message: "Có lỗi xảy ra, xin hãy thử lại sau!"));
      } else {
        final body = json.decode(response.body);
        final message = body['message'];

        if (response.statusCode == 200) {
          emit(state.copyWith(
            status: FormzStatus.submissionSuccess,
            message: message,
          ));
        } else {
          emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            message: message,
          ));
        }
      }
    }
  }
}
