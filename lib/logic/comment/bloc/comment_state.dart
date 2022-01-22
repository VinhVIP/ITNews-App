part of 'comment_bloc.dart';

enum CommentFetchStatus { loading, success, failure }

class CommentState extends Equatable {
  final List<Comment> comments;
  final CommentFetchStatus fetchStatus;
  final int idParentComment;
  final String realNameAccountParent;
  final int idCommentEdit;
  final String editContent;
  final String message;

  const CommentState({
    this.comments = const <Comment>[],
    this.fetchStatus = CommentFetchStatus.loading,
    this.idParentComment = 0,
    this.realNameAccountParent = "",
    this.idCommentEdit = 0,
    this.message = "",
    this.editContent = "",
  });

  @override
  List<Object> get props => [
        comments,
        fetchStatus,
        idParentComment,
        realNameAccountParent,
        idCommentEdit,
        message,
        editContent,
      ];

  CommentState copyWith({
    List<Comment>? comments,
    CommentFetchStatus? fetchStatus,
    int? idParentComment,
    String? realNameAccountParent,
    int? idCommentEdit,
    String? message,
    String? editContent,
  }) {
    return CommentState(
      comments: comments ?? this.comments,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      idParentComment: idParentComment ?? this.idParentComment,
      realNameAccountParent:
          realNameAccountParent ?? this.realNameAccountParent,
      idCommentEdit: idCommentEdit ?? this.idCommentEdit,
      message: message ?? "",
      editContent: editContent ?? "",
    );
  }
}
