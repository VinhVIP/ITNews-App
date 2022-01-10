part of 'posts_bloc.dart';

enum PostStatus { initial, success, failure }

class PostsState extends Equatable {
  final PostStatus fetchStatus;
  final List<PostFull> posts;
  final bool hasReachedMax;

  const PostsState({
    this.fetchStatus = PostStatus.initial,
    this.posts = const <PostFull>[],
    this.hasReachedMax = false,
  });

  @override
  List<Object> get props => [fetchStatus, posts, hasReachedMax];

  PostsState copyWith({
    PostStatus? fetchStatus,
    List<PostFull>? posts,
    bool? hasReachedMax,
  }) {
    return PostsState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
