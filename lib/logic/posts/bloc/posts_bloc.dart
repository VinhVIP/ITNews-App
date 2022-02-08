import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:it_news/data/models/post_full.dart';
import 'package:it_news/data/repositories/post_repository.dart';

part 'posts_event.dart';
part 'posts_state.dart';

enum PostType {
  newest,
  following,
  trending,
  postsOfTag,
  postsOfAuthor,
  drafts,
  public,
  unlisted,
  bookmark,
  browse,
  spam,
}

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostRepository postRepository;
  final PostType type;

  PostsBloc({required this.postRepository, required this.type})
      : super(const PostsState()) {
    on<PostsFetched>(_onPostFetched);
    on<PostsAccessChanged>(_onPostAccessChanged);
    on<PostsStatusChanged>(_onPostStatusChanged);
    on<PostsBookmarkAdded>(_onPostBookmarkAdded);
    on<PostsBookmarkDeleted>(_onPostBookmarkDeleted);
  }

  Future<void> _onPostFetched(
      PostsFetched event, Emitter<PostsState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (state.fetchStatus == PostStatus.initial) {
        final posts = await postRepository.getPosts(
          page: 1,
          type: type,
          idTag: event.idTag,
          idAccountAuthor: event.idAccountAuthor,
        );

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
          idTag: event.idTag,
          idAccountAuthor: event.idAccountAuthor,
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
      print(e);
      emit(state.copyWith(fetchStatus: PostStatus.failure));
    }
  }

  void _onPostAccessChanged(
      PostsAccessChanged event, Emitter<PostsState> emit) async {
    final response =
        await postRepository.changeAccess(event.idPost, event.access);
    if (response.statusCode == 200) {
      final List<PostFull> list = List.from(state.posts);
      list.removeWhere((post) => post.post.idPost == event.idPost);
      emit(state.copyWith(posts: list));
    } else {
      print("loi access changed");
      final body = json.decode(response.body);
      emit(state.copyWith(message: body['message']));
    }
  }

  void _onPostStatusChanged(
      PostsStatusChanged event, Emitter<PostsState> emit) async {
    final response =
        await postRepository.changeStatus(event.idPost, event.status);
    if (response.statusCode == 200) {
      final List<PostFull> list = List.from(state.posts);
      list.removeWhere((post) => post.post.idPost == event.idPost);
      emit(state.copyWith(posts: list));
    } else {
      print("loi status changed");
      final body = json.decode(response.body);
      emit(state.copyWith(message: body['message']));
    }
  }

  void _onPostBookmarkAdded(
      PostsBookmarkAdded event, Emitter<PostsState> emit) async {
    final response = await postRepository.addBookmark(event.idPost);
    if (response.statusCode == 200 || response.statusCode == 400) {
      int index =
          state.posts.indexWhere((post) => post.post.idPost == event.idPost);
      final post = state.posts[index].post.copyWith(
        bookmarkStatus: true,
        totalBookmark: state.posts[index].post.totalBookmark + 1,
      );
      final postFull = state.posts[index].copyWith(post: post);
      final List<PostFull> list = List.from(state.posts);
      list.removeAt(index);
      list.insert(index, postFull);
      emit(state.copyWith(posts: list));
    } else {
      print("loi bookmark");
      final body = json.decode(response.body);
      emit(state.copyWith(message: body['message']));
    }
  }

  void _onPostBookmarkDeleted(
      PostsBookmarkDeleted event, Emitter<PostsState> emit) async {
    final response = await postRepository.deleteBookmark(event.idPost);
    if (response.statusCode == 200 || response.statusCode == 400) {
      int index =
          state.posts.indexWhere((post) => post.post.idPost == event.idPost);
      final post = state.posts[index].post.copyWith(
        bookmarkStatus: false,
        totalBookmark: state.posts[index].post.totalBookmark - 1,
      );
      final postFull = state.posts[index].copyWith(post: post);
      final List<PostFull> list = List.from(state.posts);
      list.removeAt(index);
      list.insert(index, postFull);
      emit(state.copyWith(posts: list));
    } else {
      final body = json.decode(response.body);
      emit(state.copyWith(message: body['message']));
    }
  }
}
