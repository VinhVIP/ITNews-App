import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/data/models/post_full.dart';
import 'package:it_news/data/repositories/post_repository.dart';
import 'package:it_news/logic/post/bloc/post_bloc.dart';
import 'package:it_news/presentation/screens/post_detail/expandable_fab.dart';
import 'package:http/http.dart' as http;

import 'floating_bookmark.dart';
import 'floating_comment.dart';
import 'floating_vote.dart';
import 'post_author_appbar.dart';
import 'post_content.dart';
import 'shimmer_author.dart';

class PostPage extends StatelessWidget {
  const PostPage({Key? key, required this.post}) : super(key: key);
  final PostFull post;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostBloc(
        postRepository: PostRepository(httpClient: http.Client()),
      )..add(PostFetched(idPost: post.post.idPost)),
      child: const PostPageView(),
    );
  }
}

class PostPageView extends StatelessWidget {
  const PostPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: false,
              pinned: false,
              elevation: 4,
              forceElevated: true,
              automaticallyImplyLeading: false,
              toolbarHeight: 60,
              backgroundColor: Colors.green,
              title: BlocBuilder<PostBloc, PostState>(
                buildWhen: (previous, current) {
                  return previous.post.author != current.post.author;
                },
                builder: (context, state) {
                  if (state.fetchedStatus == PostFetchedStatus.success) {
                    return PostAuthorAppBar(author: state.post.author);
                  }
                  return const ShimmerAuthor();
                },
              ),
            ),
          ];
        },
        body: const PostContent(),
      ),
      floatingActionButton: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state.fetchedStatus == PostFetchedStatus.success) {
            return expandedFloatingActionButton(context);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget expandedFloatingActionButton(BuildContext context) {
    return const ExpandableFab(
      distance: 100.0,
      children: [
        FloatingComment(),
        FloatingBookmark(),
        FloatingVote(),
      ],
    );
  }
}
