import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/core/utils/utils.dart';
import 'package:it_news/data/models/user.dart';
import 'package:it_news/data/repositories/tag_repository.dart';
import 'package:it_news/logic/tags/bloc/tags_bloc.dart';
import 'package:it_news/presentation/components/modal_header.dart';
import 'package:http/http.dart' as http;
import 'package:it_news/presentation/screens/tags/tag_item.dart';

class TagsFollowingPage extends StatelessWidget {
  const TagsFollowingPage({Key? key, required this.author}) : super(key: key);
  final User author;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.89,
      child: Column(
        children: [
          const ModalHeader(title: 'Tags'),
          BlocProvider(
            create: (_) => TagsBloc(TagRepository(httpClient: http.Client()))
              ..add(TagsFollowingFetched(author.idAccount)),
            child: const TagsList(),
          ),
        ],
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
        }
        return Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
        );
      },
    );
  }
}
