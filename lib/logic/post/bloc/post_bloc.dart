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
}
