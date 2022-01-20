part of 'comment_bloc.dart';

abstract class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object> get props => [];
}

class CommentFetched extends CommentEvent {}

class CommentInserted extends CommentEvent {
  final int idParentComment;
  final String content;

  const CommentInserted({required this.content, this.idParentComment = 0});

  @override
  List<Object> get props => [content, idParentComment];
}

class CommentReplied extends CommentEvent {
  final int idParentComment;
  final String realNameAccountParent;

  const CommentReplied({
    this.idParentComment = 0,
    this.realNameAccountParent = "",
  });

  @override
  List<Object> get props => [idParentComment, realNameAccountParent];
}

class CommentStatusChanged extends CommentEvent {
  final int idPost;
  final int idComment;
  final int commentStatus;

  const CommentStatusChanged({
    required this.idComment,
    required this.idPost,
    required this.commentStatus,
  });

  @override
  List<Object> get props => [idComment, idPost, commentStatus];
}
