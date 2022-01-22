import 'dart:convert';

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
    on<CommentStatusChanged>(_onCommentStatusChanged);
    on<CommentEdited>(_onUiEdited);
    on<CommentUpdated>(_onCommentUpdated);
    on<CommentDeleted>(_onCommentDeleted);
  }

  void _onUiReplied(CommentReplied event, Emitter<CommentState> emit) {
    emit(state.copyWith(
      idParentComment: event.idParentComment,
      realNameAccountParent: event.realNameAccountParent,
      idCommentEdit: 0,
    ));
  }

  void _onUiEdited(CommentEdited event, Emitter<CommentState> emit) {
    emit(state.copyWith(
      idCommentEdit: event.idComment,
      editContent: event.editContent,
      idParentComment: 0,
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

  Future<void> _onCommentStatusChanged(
      CommentStatusChanged event, Emitter<CommentState> emit) async {
    final response = await postRepository.changeCommentStatus(
        post.post.idPost, event.idComment, event.commentStatus);

    if (response.statusCode == 200) {
      final List<Comment> comments = List.from(state.comments);
      for (int i = 0; i < comments.length; i++) {
        Comment cmt = comments[i];
        if (cmt.idComment == event.idComment) {
          Comment commentChange = cmt.copyWith(status: event.commentStatus);
          commentChange.replies = List.from(cmt.replies);
          comments.removeAt(i);
          comments.insert(i, commentChange);
          break;
        } else {
          // tìm kiếm các bình luận con
          bool found = false;
          for (int j = 0; j < cmt.replies.length; j++) {
            if (cmt.replies[j].idComment == event.idComment) {
              Comment commentChange =
                  cmt.replies[j].copyWith(status: event.commentStatus);
              final List<Comment> children = List.from(cmt.replies);
              children.removeAt(j);
              children.insert(j, commentChange);

              Comment parentChange = cmt.copyWith();
              parentChange.replies = List.from(children);
              comments.removeAt(i);
              comments.insert(i, parentChange);

              found = true;
              break;
            }
          }
          if (found) break;
        }
      }

      emit(state.copyWith(comments: comments));
    } else {
      final body = json.decode(response.body);
      emit(state.copyWith(message: body['message']));
    }
  }

  Future<void> _onCommentUpdated(
      CommentUpdated event, Emitter<CommentState> emit) async {
    final response = await postRepository.updateComment(
        post.post.idPost, event.idComment, event.newContent);

    if (response.statusCode == 200) {
      final List<Comment> comments = List.from(state.comments);
      for (int i = 0; i < comments.length; i++) {
        Comment cmt = comments[i];
        if (cmt.idComment == event.idComment) {
          Comment commentChange = cmt.copyWith(content: event.newContent);
          commentChange.replies = List.from(cmt.replies);
          comments.removeAt(i);
          comments.insert(i, commentChange);
          break;
        } else {
          // tìm kiếm các bình luận con
          bool found = false;
          for (int j = 0; j < cmt.replies.length; j++) {
            if (cmt.replies[j].idComment == event.idComment) {
              Comment commentChange =
                  cmt.replies[j].copyWith(content: event.newContent);
              final List<Comment> children = List.from(cmt.replies);
              children.removeAt(j);
              children.insert(j, commentChange);

              Comment parentChange = cmt.copyWith();
              parentChange.replies = List.from(children);
              comments.removeAt(i);
              comments.insert(i, parentChange);

              found = true;
              break;
            }
          }
          if (found) break;
        }
      }

      emit(state.copyWith(comments: comments));
    } else {
      final body = json.decode(response.body);
      emit(state.copyWith(message: body['message']));
    }
  }

  Future<void> _onCommentDeleted(
      CommentDeleted event, Emitter<CommentState> emit) async {
    final response =
        await postRepository.deleteComment(post.post.idPost, event.idComment);
    if (response.statusCode == 200) {
      final List<Comment> list = List.from(state.comments);
      for (int i = 0; i < list.length; i++) {
        Comment parent = list[i];
        if (parent.idComment == event.idComment) {
          list.removeAt(i);
          break;
        }
        final List<Comment> children = List.from(parent.replies);
        bool found = false;
        for (int j = 0; j < children.length; j++) {
          if (children[j].idComment == event.idComment) {
            children.removeAt(j);
            parent.replies = List.from(children);
            found = true;
            break;
          }
        }
        if (found) break;
      }

      emit(state.copyWith(comments: list));
    } else {
      final body = json.decode(response.body);
      emit(state.copyWith(message: body['message']));
    }
  }
}
