part of 'comment_bloc.dart';

enum CommentFetchStatus { loading, success, failure }

class CommentState extends Equatable {
  final List<Comment> comments;
  final CommentFetchStatus fetchStatus;
  final int idParentComment;
  final String realNameAccountParent;

  const CommentState({
    this.comments = const <Comment>[],
    this.fetchStatus = CommentFetchStatus.loading,
    this.idParentComment = 0,
    this.realNameAccountParent = "",
  });

  @override
  List<Object> get props =>
      [comments, fetchStatus, idParentComment, realNameAccountParent];

  CommentState copyWith(
      {List<Comment>? comments,
      CommentFetchStatus? fetchStatus,
      int? idParentComment,
      String? realNameAccountParent}) {
    return CommentState(
      comments: comments ?? this.comments,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      idParentComment: idParentComment ?? this.idParentComment,
      realNameAccountParent:
          realNameAccountParent ?? this.realNameAccountParent,
    );
  }
}
