import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/data/repositories/post_repository.dart';
import 'package:it_news/logic/posts/bloc/posts_bloc.dart';
import 'package:it_news/presentation/screens/tab_posts/post_list_item.dart';
import 'package:http/http.dart' as http;

class PostsPage extends StatelessWidget {
  const PostsPage({Key? key, required this.type}) : super(key: key);
  final PostType type;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostsBloc(
        postRepository: PostRepository(httpClient: http.Client()),
        type: type,
      )..add(PostsFetched()),
      child: const NewestPosts(),
    );
  }
}

class NewestPosts extends StatefulWidget {
  const NewestPosts({Key? key}) : super(key: key);

  @override
  _NewestPostsState createState() => _NewestPostsState();
}

class _NewestPostsState extends State<NewestPosts> {
  final _scrollController = ScrollController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsBloc, PostsState>(builder: (context, state) {
      loading = false;
      switch (state.fetchStatus) {
        case PostStatus.failure:
          return const Center(
            child: Text('Lỗi tải danh sách!'),
          );
        case PostStatus.success:
          if (state.posts.isEmpty) {
            return const Center(
              child: Text('Không có bài viết!'),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return index >= state.posts.length
                  ? const BottomLoader()
                  : PostListItem(
                      post: state.posts[index],
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
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      if (loading == false) {
        loading = true;
        context.read<PostsBloc>().add(PostsFetched());
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

class BottomLoader extends StatelessWidget {
  const BottomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 1.5),
      ),
    );
  }
}
