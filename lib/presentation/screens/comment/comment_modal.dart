import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/logic/comment/bloc/comment_bloc.dart';

import 'comment_item.dart';

class ModalComments extends StatefulWidget {
  const ModalComments({Key? key}) : super(key: key);

  @override
  State<ModalComments> createState() => _ModalCommentsState();
}

class _ModalCommentsState extends State<ModalComments> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<CommentBloc, CommentState>(
        buildWhen: (previous, current) {
          return previous.fetchStatus != current.fetchStatus ||
              previous.comments != current.comments;
        },
        builder: (context, state) {
          switch (state.fetchStatus) {
            case CommentFetchStatus.failure:
              return const Center(
                child: Text('Lỗi tải bình luận!'),
              );
            case CommentFetchStatus.success:
              return ListView.builder(
                itemBuilder: (context, index) {
                  return CommentItem(comment: state.comments[index]);
                },
                itemCount: state.comments.length,
              );
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
