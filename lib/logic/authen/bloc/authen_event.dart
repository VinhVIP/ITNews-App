part of 'authen_bloc.dart';

abstract class AuthenEvent extends Equatable {
  const AuthenEvent();

  @override
  List<Object> get props => [];
}

class AuthenStatusChanged extends AuthenEvent {
  final AuthenStatus status;

  const AuthenStatusChanged(this.status);

  @override
  List<Object> get props => [status];
}

class AuthenLogoutRequested extends AuthenEvent {}
