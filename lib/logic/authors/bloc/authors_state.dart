part of 'authors_bloc.dart';

enum AuthorsFetchedStatus { initial, loading, success, failure }

class AuthorsState extends Equatable {
  final List<AuthorElement> authors;
  final AuthorsFetchedStatus fetchedStatus;
  final bool hasReachedMax;
  final String keyword;
  final String message;

  const AuthorsState({
    this.authors = const <AuthorElement>[],
    this.fetchedStatus = AuthorsFetchedStatus.initial,
    this.hasReachedMax = false,
    this.keyword = "",
    this.message = "",
  });

  @override
  List<Object> get props =>
      [authors, fetchedStatus, hasReachedMax, keyword, message];

  AuthorsState copyWith({
    List<AuthorElement>? authors,
    AuthorsFetchedStatus? fetchedStatus,
    bool? hasReachedMax,
    String? keyword,
    String? message,
  }) {
    return AuthorsState(
      authors: authors ?? this.authors,
      fetchedStatus: fetchedStatus ?? this.fetchedStatus,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      keyword: keyword ?? this.keyword,
      message: message ?? "",
    );
  }

  int findAuthorElement(int idAccount) {
    for (int i = 0; i < authors.length; i++) {
      if (authors[i].author.idAccount == idAccount) return i;
    }
    return -1;
  }
}
