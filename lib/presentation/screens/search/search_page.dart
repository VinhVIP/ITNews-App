import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/data/repositories/account_repository.dart';
import 'package:it_news/data/repositories/post_repository.dart';
import 'package:it_news/data/repositories/tag_repository.dart';
import 'package:it_news/logic/authors/bloc/authors_bloc.dart';
import 'package:it_news/logic/posts/bloc/posts_bloc.dart';
import 'package:it_news/logic/tags/bloc/tags_bloc.dart';
import 'package:it_news/presentation/screens/search/search_authors.dart';
import 'package:it_news/presentation/screens/search/search_post.dart';
import 'package:http/http.dart' as http;
import 'package:it_news/presentation/screens/search/search_tags.dart';
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
      BlocProvider(
          create: (_) => TagsBloc(TagRepository(httpClient: http.Client())))
    ], child: const SearchPageView());
  }
}

class SearchPageView extends StatelessWidget {
  const SearchPageView({Key? key}) : super(key: key);

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
            cursorColor: Colors.white,
            textInputAction: TextInputAction.search,
            style: const TextStyle(color: Colors.white),
            onSubmitted: (value) {
              BlocProvider.of<PostsBloc>(context)
                  .add(PostsSearch(keyword: value, isNew: true));
              BlocProvider.of<AuthorsBloc>(context)
                  .add(AuthorsSearch(keyword: value, isNew: true));
              BlocProvider.of<TagsBloc>(context)
                  .add(TagsSearch(keyword: value, isNew: true));
            },
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              border: InputBorder.none,
              hintText: "T??m ki???m",
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
        titles: const ["T??i kho???n", "B??i vi???t", "Th???"],
        pages: const [
          SearchAuthors(),
          SearchPost(),
          SearchTags(),
        ],
      ),
    );
  }
}
