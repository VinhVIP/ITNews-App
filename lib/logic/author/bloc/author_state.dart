part of 'author_bloc.dart';

enum AuthorFetchedStatus { loading, success, failure }

class AuthorState extends Equatable {
  const AuthorState({
    this.authorElement = AuthorElement.empty,
    this.fetchedStatus = AuthorFetchedStatus.success,
    this.message = "",
  });

  final AuthorElement authorElement;
  final AuthorFetchedStatus fetchedStatus;
  final String message;

  @override
  List<Object> get props => [authorElement, fetchedStatus, message];

  AuthorState copyWith({
    AuthorElement? authorElement,
    AuthorFetchedStatus? fetchedStatus,
    String? message,
  }) {
    return AuthorState(
      authorElement: authorElement ?? this.authorElement,
      fetchedStatus: fetchedStatus ?? this.fetchedStatus,
      message: message ?? "",
    );
  }
}
