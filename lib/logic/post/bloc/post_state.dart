part of 'post_bloc.dart';

enum PostFetchedStatus { initial, loading, success, failure }
enum PostBookmarkedStatus {
  initial,
  loading,
  bookmarked,
  unbookmarked,
  failure,
}
enum PostVoteStatus { initial, loadingUp, loadingDown, voted, unvoted, failure }
enum PostWriteStatus { initial, loading, success, failure }

class PostState extends Equatable {
  final PostFull post;
  final PostFetchedStatus fetchedStatus;
  final PostBookmarkedStatus bookmarkedStatus;
  final PostVoteStatus votedStatus;
  final PostWriteStatus writeStatus;
  final String message;

  const PostState({
    this.post = PostFull.empty,
    this.fetchedStatus = PostFetchedStatus.initial,
    this.bookmarkedStatus = PostBookmarkedStatus.initial,
    this.votedStatus = PostVoteStatus.initial,
    this.writeStatus = PostWriteStatus.initial,
    this.message = "",
  });

  @override
  List<Object?> get props => [
        post,
        fetchedStatus,
        bookmarkedStatus,
        votedStatus,
        writeStatus,
        message
      ];

  PostState copyWith({
    PostFull? post,
    PostFetchedStatus? fetchedStatus,
    PostBookmarkedStatus? bookmarkedStatus,
    PostVoteStatus? votedStatus,
    PostWriteStatus? writeStatus,
    String? message,
  }) {
    return PostState(
      post: post ?? this.post,
      fetchedStatus: fetchedStatus ?? this.fetchedStatus,
      bookmarkedStatus: bookmarkedStatus ?? this.bookmarkedStatus,
      votedStatus: votedStatus ?? this.votedStatus,
      writeStatus: writeStatus ?? this.writeStatus,
      message: message ?? "",
    );
  }
}
