import 'package:equatable/equatable.dart';

import 'package:it_news/data/models/user.dart';

enum AuthorFollowStatus { loading, success, failure }

class AuthorElement extends Equatable {
  final User author;
  final AuthorFollowStatus followStatus;

  const AuthorElement(this.author, this.followStatus);

  @override
  List<Object?> get props => [author, followStatus];

  AuthorElement copyWith({
    User? author,
    AuthorFollowStatus? followStatus,
  }) {
    return AuthorElement(
      author ?? this.author,
      followStatus ?? this.followStatus,
    );
  }
}
