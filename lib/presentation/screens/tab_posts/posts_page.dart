import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/core/utils/utils.dart';
import 'package:it_news/data/repositories/post_repository.dart';
import 'package:it_news/logic/posts/bloc/posts_bloc.dart';
import 'package:it_news/presentation/screens/tab_posts/post_list_item.dart';
import 'package:http/http.dart' as http;

class PostsPage extends StatelessWidget {
  const PostsPage({
    Key? key,
    required this.type,
    this.idTag = 0,
    this.idAccountAuthor = 0,
  }) : super(key: key);

  final PostType type;
  final int idTag;
  final int idAccountAuthor;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostsBloc(
        postRepository: PostRepository(httpClient: http.Client()),
        type: type,
      )..add(
          PostsFetched(
            idTag: idTag,
            idAccountAuthor: idAccountAuthor,
          ),
        ),
      child: ListPosts(
        idTag: idTag,
        idAccountAuthor: idAccountAuthor,
      ),
    );
  }
}

class ListPosts extends StatefulWidget {
  const ListPosts({
    Key? key,
    this.idTag = 0,
    this.idAccountAuthor = 0,
  }) : super(key: key);

  final int idTag;
  final int idAccountAuthor;

  @override
  _ListPostsState createState() => _ListPostsState();
}

class _ListPostsState extends State<ListPosts> {
  final _scrollController = ScrollController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostsBloc, PostsState>(
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
            return RefreshIndicator(
              onRefresh: () async {
                context.read<PostsBloc>().add(
                      PostsFetched(
                        idTag: widget.idTag,
                        idAccountAuthor: widget.idAccountAuthor,
                        refresh: true,
                      ),
                    );
              },
              child: ListView.builder(
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
              ),
            );
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
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
        context.read<PostsBloc>().add(
              PostsFetched(
                idTag: widget.idTag,
                idAccountAuthor: widget.idAccountAuthor,
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
