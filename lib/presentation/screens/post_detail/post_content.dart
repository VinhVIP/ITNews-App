import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/logic/post/bloc/post_bloc.dart';

import 'markdown_viewer.dart';

class PostContent extends StatelessWidget {
  const PostContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      buildWhen: (previous, current) {
        return previous.post.post.content != current.post.post.content;
      },
      builder: (context, state) {
        if (state.fetchedStatus == PostFetchedStatus.success) {
          return MarkdownViewer(
            data: "# ${state.post.post.title}\n ${state.post.post.content}",
          );
        } else if (state.fetchedStatus == PostFetchedStatus.failure) {
          return const Center(
            child: Text("Lỗi tải bài viết!"),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
