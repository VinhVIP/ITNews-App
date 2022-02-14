part of 'posts_bloc.dart';

enum PostStatus { initial, success, failure, loading }

class PostsState extends Equatable {
  final PostStatus fetchStatus;
  final List<PostFull> posts;
  final bool hasReachedMax;
  final String keyword;
  final String message;

  const PostsState({
    this.fetchStatus = PostStatus.initial,
    this.posts = const <PostFull>[],
    this.hasReachedMax = false,
    this.keyword = "",
    this.message = "",
  });

  @override
  List<Object> get props =>
      [fetchStatus, posts, keyword, hasReachedMax, message];

  PostsState copyWith({
    PostStatus? fetchStatus,
    List<PostFull>? posts,
    String? keyword,
    bool? hasReachedMax,
    String? message,
  }) {
    return PostsState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      posts: posts ?? this.posts,
      keyword: keyword ?? this.keyword,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      message: message ?? "",
    );
  }
}
