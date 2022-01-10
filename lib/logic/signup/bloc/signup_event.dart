part of 'signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupAccountNameChanged extends SignupEvent {
  final String accountName;

  const SignupAccountNameChanged(this.accountName);

  @override
  List<Object> get props => [accountName];
}

class SignupRealNameChanged extends SignupEvent {
  final String realName;

  const SignupRealNameChanged(this.realName);

  @override
  List<Object> get props => [realName];
}

class SignupEmailChanged extends SignupEvent {
  final String email;

  const SignupEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class SignupPasswordChanged extends SignupEvent {
  final String password;

  const SignupPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class SignupConfirmPasswordChanged extends SignupEvent {
  final String confirmPassword;

  const SignupConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object> get props => [confirmPassword];
}

class SignupSubmitted extends SignupEvent {}
