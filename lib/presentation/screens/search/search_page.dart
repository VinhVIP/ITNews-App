import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/core/utils/utils.dart';
import 'package:it_news/data/repositories/post_repository.dart';
import 'package:it_news/logic/posts/bloc/posts_bloc.dart';
import 'package:it_news/presentation/screens/tab_posts/post_list_item.dart';
import 'package:http/http.dart' as http;
import 'package:it_news/presentation/screens/tab_posts/posts_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostsBloc(
        postRepository: PostRepository(httpClient: http.Client()),
        type: PostType.newest,
      ),
      child: const SearchPageView(),
    );
  }
}

class SearchPageView extends StatefulWidget {
  const SearchPageView({Key? key}) : super(key: key);

  @override
  State<SearchPageView> createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<SearchPageView> {
  final _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: BlocConsumer<PostsBloc, PostsState>(
        listenWhen: (previous, current) {
          return current.message.isNotEmpty;
        },
        listener: (context, state) {
          Utils.showMessageDialog(
              context: context, title: "Thông báo", content: state.message);
        },
        builder: (context, state) {
          loading = false;
          switch (state.fetchStatus) {
            case PostStatus.initial:
              return const Center(
                child: Text('Nhập từ khóa tìm để tìm kiếm!'),
              );
            case PostStatus.failure:
              return const Center(
                child: Text('Lỗi tìm kiếm!'),
              );
            case PostStatus.success:
              if (state.posts.isEmpty) {
                return const Center(
                  child: Text('Không có kết quả!'),
                );
              }
              return ListView.builder(
                itemBuilder: (context, index) {
                  return index >= state.posts.length
                      ? const BottomLoader()
                      : PostListItem(
                          post: state.posts[index],
                          ctx: context,
                        );
                },
                itemCount: state.hasReachedMax
                    ? state.posts.length
                    : state.posts.length + 1,
                controller: _scrollController,
              );
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _controller.dispose();

    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      if (loading == false) {
        loading = true;
        context.read<PostsBloc>().add(
              PostsSearch(
                keyword: _controller.text.trim(),
                isNew: false,
              ),
            );
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
