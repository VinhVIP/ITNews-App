import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/data/models/post_full.dart';
import 'package:it_news/data/repositories/post_repository.dart';
import 'package:it_news/logic/comment/bloc/comment_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:it_news/presentation/screens/comment/comment_input.dart';
import 'package:it_news/presentation/screens/comment/comment_modal_header.dart';

import 'comment_modal.dart';

class CommentsPage extends StatelessWidget {
  const CommentsPage({Key? key, required this.post}) : super(key: key);
  final PostFull post;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CommentBloc(
        postRepository: PostRepository(httpClient: http.Client()),
        post: post,
      )..add(CommentFetched()),
      child: FractionallySizedBox(
        heightFactor: 0.89,
        child: Column(
          children: [
            const ModalCommentsHeader(),
            ModalComments(idPost: post.post.idPost),
            const CommentInput(),
          ],
        ),
      ),
    );
  }
}
