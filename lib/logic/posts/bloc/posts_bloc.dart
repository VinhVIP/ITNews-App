import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:it_news/data/models/post_full.dart';
import 'package:it_news/data/repositories/post_repository.dart';

part 'posts_event.dart';
part 'posts_state.dart';

enum PostType { newest, following, trending }

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostRepository postRepository;
  final PostType type;

  PostsBloc({required this.postRepository, required this.type})
      : super(const PostsState()) {
    on<PostsFetched>(_onPostFetched);
  }

  Future<void> _onPostFetched(
    PostsFetched event,
    Emitter<PostsState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.fetchStatus == PostStatus.initial) {
        final posts = await postRepository.getPosts(page: 1, type: type);
        emit(state.copyWith(
          fetchStatus: PostStatus.success,
          posts: posts,
          hasReachedMax: posts!.length < 10 ? true : false,
        ));
      } else {
        int size = state.posts.length;
        final nextPage = (size / 10).ceil() + 1;
        final posts = await postRepository.getPosts(
          page: nextPage,
          type: type,
        );
        if (posts == null || posts.isEmpty) {
          emit(state.copyWith(hasReachedMax: true));
        } else {
          emit(state.copyWith(
              fetchStatus: PostStatus.success,
              posts: List.from(state.posts)..addAll(posts),
              hasReachedMax: posts.length < 10 ? true : false));
        }
      }
    } catch (e) {
      emit(state.copyWith(fetchStatus: PostStatus.failure));
    }
  }
}
