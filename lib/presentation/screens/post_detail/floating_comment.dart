import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/logic/post/bloc/post_bloc.dart';
import 'package:it_news/presentation/screens/comment/comments_page.dart';

class FloatingComment extends StatelessWidget {
  const FloatingComment({Key? key}) : super(key: key);

  void showComments(context, post) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return CommentsPage(post: post);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        return Column(
          children: [
            Material(
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              color: Colors.green,
              elevation: 4.0,
              child: IconButton(
                color: Colors.white,
                onPressed: () {
                  showComments(context, state.post);
                },
                icon: const Icon(Icons.comment),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              state.post.post.totalComment.toString(),
              style: const TextStyle(color: Colors.green),
            ),
          ],
        );
      },
    );
  }
}
