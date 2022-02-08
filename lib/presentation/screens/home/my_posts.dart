import 'package:flutter/material.dart';
import 'package:it_news/logic/posts/bloc/posts_bloc.dart';
import 'package:it_news/presentation/screens/tab_posts/posts_page.dart';
import 'package:scroll_navigation/scroll_navigation.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({Key? key}) : super(key: key);

  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  @override
  Widget build(BuildContext context) {
    return TitleScrollNavigation(
      barStyle: const TitleNavigationBarStyle(
        style: TextStyle(fontWeight: FontWeight.bold),
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
        spaceBetween: 40,
      ),
      titles: const ["Công khai", "Nháp", "Ẩn link", "Bookmark"],
      pages: const [
        PostsPage(type: PostType.public),
        PostsPage(type: PostType.drafts),
        PostsPage(type: PostType.unlisted),
        PostsPage(type: PostType.bookmark),
      ],
    );
  }
}
