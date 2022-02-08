import 'package:flutter/material.dart';
import 'package:it_news/logic/posts/bloc/posts_bloc.dart';
import 'package:it_news/presentation/screens/tab_posts/posts_page.dart';

class BrowsePage extends StatelessWidget {
  const BrowsePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài viết chờ kiểm duyệt'),
      ),
      body: const PostsPage(
        type: PostType.browse,
      ),
    );
  }
}
