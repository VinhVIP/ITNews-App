import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:it_news/data/models/comment.dart';
import 'package:it_news/data/models/post_full.dart';
import 'package:it_news/data/repositories/post_repository.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final PostRepository postRepository;
  final PostFull post;

  CommentBloc({
    required this.postRepository,
    required this.post,
  }) : super(const CommentState()) {
    on<CommentFetched>(_onCommentFetched);
    on<CommentInserted>(_onCommentInserted);
    on<CommentReplied>(_onUiReplied);
  }

  void _onUiReplied(CommentReplied event, Emitter<CommentState> emit) {
    emit(state.copyWith(
      idParentComment: event.idParentComment,
      realNameAccountParent: event.realNameAccountParent,
    ));
  }

  Future<void> _onCommentFetched(
      CommentFetched event, Emitter<CommentState> emit) async {
    emit(state.copyWith(fetchStatus: CommentFetchStatus.loading));
    try {
      final comments = await postRepository.getCommentsOfPost(post.post.idPost);
      emit(
        state.copyWith(
          comments: comments,
          fetchStatus: CommentFetchStatus.success,
        ),
      );
    } catch (e) {
      emit(state.copyWith(fetchStatus: CommentFetchStatus.failure));
    }
  }

  Future<void> _onCommentInserted(
      CommentInserted event, Emitter<CommentState> emit) async {
    try {
      if (event.idParentComment == 0) {
        final comment =
            await postRepository.insertComment(post.post.idPost, event.content);
        if (comment != null) {
          emit(state.copyWith(
            comments: List.from(state.comments)..insert(0, comment),
          ));
        }
      } else {
        final int idParentComment = event.idParentComment;
        final comment = await postRepository.insertReplyComment(
            post.post.idPost, event.idParentComment, event.content);

        List<Comment> list = List.from(state.comments);
        for (int i = 0; i < list.length; i++) {
          list[i].replies = List.from(state.comments[i].replies);
          if (list[i].idComment == idParentComment) {
            list[i].replies.add(comment!);
          }
        }
        emit(state.copyWith(fetchStatus: CommentFetchStatus.loading));
        emit(state.copyWith(
            comments: list, fetchStatus: CommentFetchStatus.success));
      }
    } catch (e) {
      print(e);
    }
  }
}
