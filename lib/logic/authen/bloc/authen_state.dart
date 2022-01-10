part of 'authen_bloc.dart';

class AuthenState extends Equatable {
  final AuthenStatus status;
  final User user;

  const AuthenState._({
    this.status = AuthenStatus.unknown,
    this.user = User.empty,
  });

  const AuthenState.unknown() : this._();

  const AuthenState.authenticated(User user)
      : this._(status: AuthenStatus.authenticated, user: user);

  const AuthenState.unauthenticated()
      : this._(status: AuthenStatus.unauthenticated);

  @override
  List<Object> get props => [status, user];
}
