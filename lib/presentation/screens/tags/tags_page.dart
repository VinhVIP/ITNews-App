import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/core/utils/utils.dart';
import 'package:it_news/data/repositories/tag_repository.dart';
import 'package:it_news/logic/tags/bloc/tags_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:it_news/presentation/screens/tags/tag_item.dart';

class TagsPage extends StatelessWidget {
  const TagsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tất cả thẻ"),
      ),
      body: BlocProvider(
        create: (_) => TagsBloc(TagRepository(httpClient: http.Client()))
          ..add(TagsFetched(Utils.user.idAccount)),
        child: const TagsList(),
      ),
    );
  }
}

class TagsList extends StatelessWidget {
  const TagsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TagsBloc, TagsState>(
      listenWhen: (previous, current) {
        return current.message.isNotEmpty;
      },
      listener: (context, state) {
        Utils.showMessageDialog(
          context: context,
          title: "Thông báo",
          content: state.message,
        );
      },
      builder: (context, state) {
        if (state.fetchedStatus == TagsFetchedStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.fetchedStatus == TagsFetchedStatus.failure) {
          return const Center(
            child: Text('Lỗi tải danh sách thẻ!'),
          );
        } else if (state.fetchedStatus == TagsFetchedStatus.initial) {
          return const Center(
            child: Text('Nhập từ khóa cần tìm kiếm!'),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            context.read<TagsBloc>().add(TagsFetched(Utils.user.idAccount));
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 5.0,
              ),
              itemBuilder: (context, index) {
                return TagItem(tagElement: state.tags[index]);
              },
              itemCount: state.tags.length,
            ),
          ),
        );
      },
    );
  }
}
