import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/core/utils/utils.dart';
import 'package:it_news/data/models/user.dart';
import 'package:it_news/data/repositories/account_repository.dart';
import 'package:it_news/logic/authors/bloc/authors_bloc.dart';
import 'package:it_news/presentation/components/modal_header.dart';
import 'package:http/http.dart' as http;
import 'package:it_news/presentation/screens/authors/author_item.dart';

class FollowingsPage extends StatelessWidget {
  const FollowingsPage({Key? key, required this.author}) : super(key: key);
  final User author;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.89,
      child: Column(
        children: [
          const ModalHeader(title: 'Followings'),
          BlocProvider(
            create: (_) =>
                AuthorsBloc(AccountRepository(httpClient: http.Client()))
                  ..add(AuthorFollowingsFetched(author.idAccount)),
            child: const FolllowingsList(),
          ),
        ],
      ),
    );
  }
}

class FolllowingsList extends StatelessWidget {
  const FolllowingsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocConsumer<AuthorsBloc, AuthorsState>(
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
          switch (state.fetchedStatus) {
            case AuthorsFetchedStatus.failure:
              return const Center(
                child: Text('Lỗi tải danh sách'),
              );
            case AuthorsFetchedStatus.success:
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemBuilder: (context, index) {
                  return AuthorItem(
                    authorElement: state.authors[index],
                  );
                },
                itemCount: state.authors.length,
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
}
