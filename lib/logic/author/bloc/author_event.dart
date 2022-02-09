part of 'author_bloc.dart';

abstract class AuthorEvent extends Equatable {
  const AuthorEvent();

  @override
  List<Object> get props => [];
}

class AuthorFetched extends AuthorEvent {
  final int idAccount;

  const AuthorFetched(this.idAccount);

  @override
  List<Object> get props => [idAccount];
}

class AuthorViewUser extends AuthorEvent {
  final User user;

  const AuthorViewUser(this.user);

  @override
  List<Object> get props => [user];
}

class AuthorFollowed extends AuthorEvent {
  final int idAccount;

  const AuthorFollowed(this.idAccount);

  @override
  List<Object> get props => [idAccount];
}

class AuthorUnFollowed extends AuthorEvent {
  final int idAccount;

  const AuthorUnFollowed(this.idAccount);

  @override
  List<Object> get props => [idAccount];
}

class AuthorRoleChanged extends AuthorEvent {
  final int idAccount;
  final int role;

  const AuthorRoleChanged({required this.idAccount, required this.role});

  @override
  List<Object> get props => [idAccount, role];
}

class AuthorLockedTime extends AuthorEvent {
  final int idAccount;
  final String reason;
  final int hoursLock;

  const AuthorLockedTime({
    required this.idAccount,
    required this.reason,
    required this.hoursLock,
  });

  @override
  List<Object> get props => [idAccount, reason, hoursLock];
}

class AuthorLockedForever extends AuthorEvent {
  final int idAccount;
  final String reason;

  const AuthorLockedForever({required this.idAccount, required this.reason});

  @override
  List<Object> get props => [idAccount, reason];
}

class AuthorUnlocked extends AuthorEvent {
  final int idAccount;

  const AuthorUnlocked(this.idAccount);

  @override
  List<Object> get props => [idAccount];
}
