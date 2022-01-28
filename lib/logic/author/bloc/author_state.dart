part of 'author_bloc.dart';

enum AuthorFetchedStatus { loading, success, failure }

class AuthorState extends Equatable {
  const AuthorState({
    this.authorElement = AuthorElement.empty,
    this.fetchedStatus = AuthorFetchedStatus.success,
  });

  final AuthorElement authorElement;
  final AuthorFetchedStatus fetchedStatus;

  @override
  List<Object> get props => [authorElement, fetchedStatus];

  AuthorState copyWith({
    AuthorElement? authorElement,
    AuthorFetchedStatus? fetchedStatus,
  }) {
    return AuthorState(
      authorElement: authorElement ?? this.authorElement,
      fetchedStatus: fetchedStatus ?? this.fetchedStatus,
    );
  }
}
