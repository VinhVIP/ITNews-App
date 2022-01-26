import 'package:flutter/material.dart';
import 'package:it_news/data/models/user.dart';
import 'package:it_news/logic/posts/bloc/posts_bloc.dart';
import 'package:it_news/presentation/screens/tab_posts/posts_page.dart';

class PostsOfAuthor extends StatelessWidget {
  const PostsOfAuthor({Key? key, required this.author}) : super(key: key);

  final User author;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bài viết của ${author.realName}'),
      ),
      body: PostsPage(
        type: PostType.postsOfAuthor,
        idAccountAuthor: author.idAccount,
      ),
    );
  }
}
