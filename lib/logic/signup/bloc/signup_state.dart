part of 'signup_bloc.dart';

class SignupState extends Equatable {
  final AccountName accountName;
  final RealName realName;
  final Email email;
  final Password password;
  final ConfirmPassword confirmPassword;
  final FormzStatus status;
  final String message;

  const SignupState({
    this.accountName = const AccountName.pure(),
    this.realName = const RealName.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.status = FormzStatus.pure,
    this.message = "",
  });

  @override
  List<Object> get props => [
        accountName,
        realName,
        email,
        password,
        confirmPassword,
        status,
        message
      ];

  SignupState copyWith({
    AccountName? accountName,
    RealName? realName,
    Email? email,
    Password? password,
    ConfirmPassword? confirmPassword,
    FormzStatus? status,
    String? message,
  }) {
    return SignupState(
      accountName: accountName ?? this.accountName,
      realName: realName ?? this.realName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
