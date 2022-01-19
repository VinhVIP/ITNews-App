part of 'post_bloc.dart';

enum PostFetchedStatus { initial, loading, success, failure }
enum PostBookmarkedStatus {
  initial,
  loading,
  bookmarked,
  unbookmarked,
  failure
}

class PostState extends Equatable {
  final PostFull post;
  final PostFetchedStatus fetchedStatus;
  final PostBookmarkedStatus bookmarkedStatus;

  const PostState({
    this.post = PostFull.empty,
    this.fetchedStatus = PostFetchedStatus.initial,
    this.bookmarkedStatus = PostBookmarkedStatus.initial,
  });

  @override
  List<Object?> get props => [post, fetchedStatus, bookmarkedStatus];

  PostState copyWith({
    PostFull? post,
    PostFetchedStatus? fetchedStatus,
    PostBookmarkedStatus? bookmarkedStatus,
  }) {
    return PostState(
      post: post ?? this.post,
      fetchedStatus: fetchedStatus ?? this.fetchedStatus,
      bookmarkedStatus: bookmarkedStatus ?? this.bookmarkedStatus,
    );
  }
}
