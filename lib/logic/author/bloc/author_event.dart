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
