part of 'posts_bloc.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

class PostsFetched extends PostsEvent {
  final int idTag;
  final int idAccountAuthor;
  final bool refresh;

  const PostsFetched({
    this.idTag = 0,
    this.idAccountAuthor = 0,
    this.refresh = false,
  });

  @override
  List<Object> get props => [idTag, idAccountAuthor, refresh];
}

class PostsAccessChanged extends PostsEvent {
  final int idPost;
  final int access;

  const PostsAccessChanged({required this.idPost, required this.access});

  @override
  List<Object> get props => [idPost, access];
}

class PostsStatusChanged extends PostsEvent {
  final int idPost;
  final int status;

  const PostsStatusChanged({required this.idPost, required this.status});

  @override
  List<Object> get props => [idPost, status];
}

class PostsBookmarkAdded extends PostsEvent {
  final int idPost;

  const PostsBookmarkAdded(this.idPost);

  @override
  List<Object> get props => [idPost];
}

class PostsBookmarkDeleted extends PostsEvent {
  final int idPost;

  const PostsBookmarkDeleted(this.idPost);

  @override
  List<Object> get props => [idPost];
}
