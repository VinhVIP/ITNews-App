part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class PostFetched extends PostEvent {
  final int idPost;
  const PostFetched({required this.idPost});

  @override
  List<Object> get props => [idPost];
}

class PostBookmarkAdded extends PostEvent {
  final int idPost;

  const PostBookmarkAdded(this.idPost);

  @override
  List<Object> get props => [idPost];
}

class PostBookmarkDeleted extends PostEvent {
  final int idPost;

  const PostBookmarkDeleted(this.idPost);

  @override
  List<Object> get props => [idPost];
}

class PostVoteAdded extends PostEvent {
  final int idPost;
  final int voteType;

  static const int VOTEUP = 1;
  static const int VOTEDOWN = 0;

  const PostVoteAdded({required this.idPost, required this.voteType});

  @override
  List<Object> get props => [idPost, voteType];
}

class PostVoteDeleted extends PostEvent {
  final int idPost;
  final int previousVoteType;

  const PostVoteDeleted({required this.idPost, required this.previousVoteType});

  @override
  List<Object> get props => [idPost, previousVoteType];
}

class PostStatusChanged extends PostEvent {
  final int idPost;
  final int status;

  const PostStatusChanged({required this.idPost, required this.status});

  @override
  List<Object> get props => [idPost, status];
}

class PostAccessChanged extends PostEvent {
  final int idPost;
  final int access;

  const PostAccessChanged({required this.idPost, required this.access});

  @override
  List<Object> get props => [idPost, access];
}

class PostWriteEvent extends PostEvent {
  final String title;
  final String content;
  final int access;
  final List<int> tags;

  const PostWriteEvent({
    required this.title,
    required this.content,
    required this.access,
    required this.tags,
  });

  @override
  List<Object> get props => [title, content, access, tags];
}

class PostUpdatedEvent extends PostEvent {
  final int idPost;
  final String title;
  final String content;
  final int access;
  final List<int> tags;

  const PostUpdatedEvent({
    required this.idPost,
    required this.title,
    required this.content,
    required this.access,
    required this.tags,
  });

  @override
  List<Object> get props => [idPost, title, content, access, tags];
}
