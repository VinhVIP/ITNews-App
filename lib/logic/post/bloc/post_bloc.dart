import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:it_news/data/models/post_full.dart';
import 'package:it_news/data/repositories/post_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;

  PostBloc({required this.postRepository}) : super(const PostState()) {
    on<PostFetched>(_onPostFetched);
    on<PostBookmarkAdded>(_onPostBookmarkAdded);
    on<PostBookmarkDeleted>(_onPostBookmarkDeleted);
    on<PostVoteAdded>(_onPostVoteAdded);
    on<PostVoteDeleted>(_onPostVoteDeleted);
    on<PostStatusChanged>(_onPostStatusChanged);
    on<PostAccessChanged>(_onPostAccessChanged);
  }

  Future<void> _onPostFetched(
      PostFetched event, Emitter<PostState> emit) async {
    emit(state.copyWith(fetchedStatus: PostFetchedStatus.loading));

    final post = await postRepository.getPost(event.idPost);
    if (post != null) {
      emit(state.copyWith(
        post: post,
        fetchedStatus: PostFetchedStatus.success,
      ));
    } else {
      emit(state.copyWith(
        fetchedStatus: PostFetchedStatus.failure,
      ));
    }
  }

  Future<void> _onPostBookmarkAdded(
      PostBookmarkAdded event, Emitter<PostState> emit) async {
    emit(state.copyWith(bookmarkedStatus: PostBookmarkedStatus.loading));

    final response = await postRepository.addBookmark(event.idPost);
    if (response.statusCode == 200 || response.statusCode == 400) {
      final totalBookmark = state.post.post.totalBookmark;
      final post = state.post.post.copyWith(
        bookmarkStatus: true,
        totalBookmark: totalBookmark + 1,
      );

      emit(state.copyWith(
          bookmarkedStatus: PostBookmarkedStatus.bookmarked,
          post: state.post.copyWith(post: post)));
    } else {
      emit(state.copyWith(bookmarkedStatus: PostBookmarkedStatus.failure));
    }
  }

  Future<void> _onPostBookmarkDeleted(
      PostBookmarkDeleted event, Emitter<PostState> emit) async {
    emit(state.copyWith(bookmarkedStatus: PostBookmarkedStatus.loading));
    final response = await postRepository.deleteBookmark(event.idPost);
    if (response.statusCode == 200 || response.statusCode == 400) {
      final totalBookmark = state.post.post.totalBookmark;
      final post = state.post.post.copyWith(
        bookmarkStatus: false,
        totalBookmark: totalBookmark - 1,
      );

      emit(state.copyWith(
          bookmarkedStatus: PostBookmarkedStatus.unbookmarked,
          post: state.post.copyWith(post: post)));
    } else {
      emit(state.copyWith(bookmarkedStatus: PostBookmarkedStatus.failure));
    }
  }

  Future<void> _onPostVoteAdded(
      PostVoteAdded event, Emitter<PostState> emit) async {
    if (event.voteType == PostVoteAdded.VOTEUP) {
      emit(state.copyWith(votedStatus: PostVoteStatus.loadingUp));
    } else {
      emit(state.copyWith(votedStatus: PostVoteStatus.loadingDown));
    }
    final response = await postRepository.addVote(event.idPost, event.voteType);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final totalVoteUp = await postRepository.getTotalVoteUp(event.idPost);
      final totalVoteDown = await postRepository.getTotalVoteDown(event.idPost);

      final post = state.post.post.copyWith(
        voteType: event.voteType,
        totalVoteUp: totalVoteUp,
        totalVoteDown: totalVoteDown,
      );

      emit(state.copyWith(
        votedStatus: PostVoteStatus.voted,
        post: state.post.copyWith(post: post),
      ));
    } else {
      emit(state.copyWith(votedStatus: PostVoteStatus.failure));
    }
  }

  Future<void> _onPostVoteDeleted(
      PostVoteDeleted event, Emitter<PostState> emit) async {
    if (event.previousVoteType == PostVoteAdded.VOTEUP) {
      emit(state.copyWith(votedStatus: PostVoteStatus.loadingUp));
    } else {
      emit(state.copyWith(votedStatus: PostVoteStatus.loadingDown));
    }
    final response = await postRepository.deleteVote(event.idPost);
    if (response.statusCode == 200) {
      final totalVoteUp = await postRepository.getTotalVoteUp(event.idPost);
      final totalVoteDown = await postRepository.getTotalVoteDown(event.idPost);

      final post = state.post.post.copyWith(
        voteType: -1,
        totalVoteUp: totalVoteUp,
        totalVoteDown: totalVoteDown,
      );

      emit(state.copyWith(
        votedStatus: PostVoteStatus.unvoted,
        post: state.post.copyWith(post: post),
      ));
    } else {
      emit(state.copyWith(votedStatus: PostVoteStatus.failure));
    }
  }

  void _onPostStatusChanged(
      PostStatusChanged event, Emitter<PostState> emit) async {
    final response =
        await postRepository.changeStatus(event.idPost, event.status);
    final body = json.decode(response.body);
    final message = body['message'];
    if (response.statusCode == 200) {
      final post = state.post.post.copyWith(status: event.status);
      emit(state.copyWith(
          post: state.post.copyWith(post: post), message: message));
    } else {
      emit(state.copyWith(message: message));
    }
  }

  void _onPostAccessChanged(
      PostAccessChanged event, Emitter<PostState> emit) async {
    final response =
        await postRepository.changeAccess(event.idPost, event.access);
    final body = json.decode(response.body);
    final message = body['message'];
    if (response.statusCode == 200) {
      final post = state.post.post.copyWith(access: event.access);
      emit(state.copyWith(
          post: state.post.copyWith(post: post), message: message));
    } else {
      emit(state.copyWith(message: message));
    }
  }
}
