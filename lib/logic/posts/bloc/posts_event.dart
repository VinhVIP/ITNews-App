part of 'posts_bloc.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

class PostsFetched extends PostsEvent {
  final int idTag;
  final int idAccountAuthor;

  const PostsFetched({
    this.idTag = 0,
    this.idAccountAuthor = 0,
  });

  @override
  List<Object> get props => [idTag, idAccountAuthor];
}

class PostAccessChanged extends PostsEvent {
  final int idPost;
  final int access;

  const PostAccessChanged({required this.idPost, required this.access});

  @override
  List<Object> get props => [idPost, access];
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
