import 'package:flutter/material.dart';
import 'package:it_news/data/models/tag.dart';
import 'package:it_news/logic/posts/bloc/posts_bloc.dart';
import 'package:it_news/presentation/screens/tab_posts/posts_page.dart';

class PostsOfTag extends StatelessWidget {
  const PostsOfTag({Key? key, required this.tag}) : super(key: key);

  final Tag tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bài viết thuộc thẻ ${tag.name}'),
      ),
      body: PostsPage(
        type: PostType.postsOfTag,
        idTag: tag.idTag,
      ),
    );
  }
}
