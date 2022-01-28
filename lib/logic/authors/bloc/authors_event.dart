part of 'authors_bloc.dart';

abstract class AuthorsEvent extends Equatable {
  const AuthorsEvent();

  @override
  List<Object> get props => [];
}

class AuthorsFetched extends AuthorsEvent {}

class AuthorFollowed extends AuthorsEvent {
  final int idAccount;

  const AuthorFollowed(this.idAccount);

  @override
  List<Object> get props => [idAccount];
}

class AuthorUnFollowed extends AuthorsEvent {
  final int idAccount;

  const AuthorUnFollowed(this.idAccount);

  @override
  List<Object> get props => [idAccount];
}

class AuthorFollowersFetched extends AuthorsEvent {
  final int idAccount;

  const AuthorFollowersFetched(this.idAccount);

  @override
  List<Object> get props => [idAccount];
}

class AuthorFollowingsFetched extends AuthorsEvent {
  final int idAccount;

  const AuthorFollowingsFetched(this.idAccount);

  @override
  List<Object> get props => [idAccount];
}
