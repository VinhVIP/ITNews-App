import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/data/repositories/account_repository.dart';
import 'package:it_news/data/repositories/post_repository.dart';
import 'package:it_news/logic/authors/bloc/authors_bloc.dart';
import 'package:it_news/logic/posts/bloc/posts_bloc.dart';
import 'package:it_news/presentation/screens/search/search_authors.dart';
import 'package:it_news/presentation/screens/search/search_post.dart';
import 'package:http/http.dart' as http;
import 'package:scroll_navigation/misc/navigation_helpers.dart';
import 'package:scroll_navigation/navigation/title_scroll_navigation.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) => PostsBloc(
          postRepository: PostRepository(httpClient: http.Client()),
          type: PostType.newest,
        ),
      ),
      BlocProvider(
        create: (_) =>
            AuthorsBloc(AccountRepository(httpClient: http.Client())),
      ),
    ], child: const SearchPageView());
  }
}

class SearchPageView extends StatefulWidget {
  const SearchPageView({Key? key}) : super(key: key);

  @override
  State<SearchPageView> createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<SearchPageView> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        titleSpacing: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          margin: const EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            controller: _controller,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.search,
            style: const TextStyle(color: Colors.white),
            onSubmitted: (value) {
              BlocProvider.of<PostsBloc>(context)
                  .add(PostsSearch(keyword: value, isNew: true));
              BlocProvider.of<AuthorsBloc>(context)
                  .add(AuthorsSearch(keyword: value, isNew: true));
            },
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              border: InputBorder.none,
              hintText: "Tìm kiếm",
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ),
      body: TitleScrollNavigation(
        barStyle: const TitleNavigationBarStyle(
          style: TextStyle(fontWeight: FontWeight.bold),
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
          spaceBetween: 40,
        ),
        titles: const ["Tài khoản", "Bài viết", "Thẻ"],
        pages: [
          SearchAuthors(keyword: _controller.text.trim()),
          SearchPost(keyword: _controller.text.trim()),
          const Center(
            child: Text("Tab 3"),
          ),
        ],
      ),
    );
  }
}
