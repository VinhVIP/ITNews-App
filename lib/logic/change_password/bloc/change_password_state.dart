part of 'change_password_bloc.dart';

enum ChangePasswordStatus { loading, success, failure }

class ChangePasswordState extends Equatable {
  final String message;
  final ChangePasswordStatus status;

  const ChangePasswordState({
    this.message = "",
    this.status = ChangePasswordStatus.success,
  });

  @override
  List<Object> get props => [message, status];

  ChangePasswordState copyWith({
    String? message,
    ChangePasswordStatus? status,
  }) {
    return ChangePasswordState(
      message: message ?? "",
      status: status ?? this.status,
    );
  }
}
