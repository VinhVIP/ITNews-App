import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/core/utils/utils.dart';
import 'package:it_news/logic/posts/bloc/posts_bloc.dart';
import 'package:it_news/presentation/screens/tab_posts/post_list_item.dart';
import 'package:it_news/presentation/screens/tab_posts/posts_page.dart';

class SearchPost extends StatefulWidget {
  const SearchPost({Key? key, required this.keyword}) : super(key: key);
  final String keyword;

  @override
  State<SearchPost> createState() => _SearchPostState();
}

class _SearchPostState extends State<SearchPost> {
  final _scrollController = ScrollController();
  bool loading = false;

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

    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      if (loading == false) {
        loading = true;
        context.read<PostsBloc>().add(
              PostsSearch(
                keyword: widget.keyword,
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
