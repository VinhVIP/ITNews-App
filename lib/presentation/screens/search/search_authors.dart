import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/core/utils/utils.dart';
import 'package:it_news/logic/authors/bloc/authors_bloc.dart';
import 'package:it_news/presentation/screens/authors/author_item.dart';
import 'package:it_news/presentation/screens/tab_posts/posts_page.dart';

class SearchAuthors extends StatefulWidget {
  const SearchAuthors({Key? key, required this.keyword}) : super(key: key);
  final String keyword;

  @override
  State<SearchAuthors> createState() => _SearchAuthorsState();
}

class _SearchAuthorsState extends State<SearchAuthors> {
  final _scrollController = ScrollController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthorsBloc, AuthorsState>(
      listenWhen: (previous, current) {
        return current.message.isNotEmpty;
      },
      listener: (context, state) {
        Utils.showMessageDialog(
            context: context, title: "Thông báo", content: state.message);
      },
      builder: (context, state) {
        loading = false;
        switch (state.fetchedStatus) {
          case AuthorsFetchedStatus.initial:
            return const Center(
              child: Text('Nhập từ khóa tìm để tìm kiếm!'),
            );
          case AuthorsFetchedStatus.failure:
            return const Center(
              child: Text('Lỗi tìm kiếm!'),
            );
          case AuthorsFetchedStatus.success:
            if (state.authors.isEmpty) {
              return const Center(
                child: Text('Không có kết quả!'),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(5),
              itemBuilder: (context, index) {
                return index >= state.authors.length
                    ? const BottomLoader()
                    : AuthorItem(authorElement: state.authors[index]);
              },
              itemCount: state.hasReachedMax
                  ? state.authors.length
                  : state.authors.length + 1,
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
        context.read<AuthorsBloc>().add(
              AuthorsSearch(
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
