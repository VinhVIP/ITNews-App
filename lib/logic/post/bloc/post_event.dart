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
