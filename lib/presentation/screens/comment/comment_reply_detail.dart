import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/logic/comment/bloc/comment_bloc.dart';

class CommentReplyDetail extends StatelessWidget {
  const CommentReplyDetail({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      buildWhen: (previous, current) =>
          previous.idParentComment != current.idParentComment,
      builder: (context, state) {
        if (state.idParentComment != 0) {
          return Row(
            children: [
              IconButton(
                onPressed: () {
                  context.read<CommentBloc>().add(const CommentReplied());
                },
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 18.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Trả lời ${context.select((CommentBloc bloc) => bloc.state.realNameAccountParent)}",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
