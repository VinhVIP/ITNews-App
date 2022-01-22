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

class CommentEdited extends CommentEvent {
  final int idComment;
  final String editContent;

  const CommentEdited({this.idComment = 0, this.editContent = ""});

  @override
  List<Object> get props => [idComment];
}

class CommentUpdated extends CommentEvent {
  final int idComment;
  final String newContent;

  const CommentUpdated({required this.idComment, required this.newContent});

  @override
  List<Object> get props => [idComment, newContent];
}

class CommentStatusChanged extends CommentEvent {
  final int idComment;
  final int commentStatus;

  const CommentStatusChanged({
    required this.idComment,
    required this.commentStatus,
  });

  @override
  List<Object> get props => [idComment, commentStatus];
}

class CommentDeleted extends CommentEvent {
  final int idComment;

  const CommentDeleted(this.idComment);

  @override
  List<Object> get props => [idComment];
}
