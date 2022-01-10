import 'package:flutter/material.dart';
import 'package:it_news/logic/posts/bloc/posts_bloc.dart';
import 'package:it_news/presentation/screens/tab_posts/posts_page.dart';
import 'package:scroll_navigation/scroll_navigation.dart';

class TabPosts extends StatefulWidget {
  const TabPosts({Key? key}) : super(key: key);

  @override
  _TabPostsState createState() => _TabPostsState();
}

class _TabPostsState extends State<TabPosts> {
  @override
  Widget build(BuildContext context) {
    return TitleScrollNavigation(
      barStyle: const TitleNavigationBarStyle(
        style: TextStyle(fontWeight: FontWeight.bold),
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
        spaceBetween: 40,
      ),
      titles: const ["Mới nhất", "Đang theo dõi", "Nổi bật"],
      pages: const [
        PostsPage(type: PostType.newest),
        PostsPage(type: PostType.following),
        PostsPage(type: PostType.trending),
      ],
    );
  }
}
