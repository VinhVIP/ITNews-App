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
