import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/core/utils/utils.dart';
import 'package:it_news/data/repositories/account_repository.dart';
import 'package:it_news/logic/authors/bloc/authors_bloc.dart';
import 'package:it_news/presentation/screens/authors/author_item.dart';
import 'package:http/http.dart' as http;

class AuthorsPage extends StatelessWidget {
  const AuthorsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Tất cả tác giả"),
      ),
      body: BlocProvider(
        create: (_) => AuthorsBloc(AccountRepository(httpClient: http.Client()))
          ..add(AuthorsFetched()),
        child: const AuthorsList(),
      ),
    );
  }
}

class AuthorsList extends StatelessWidget {
  const AuthorsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthorsBloc, AuthorsState>(
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
        if (state.fetchedStatus == AuthorsFetchedStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.fetchedStatus == AuthorsFetchedStatus.failure) {
          return const Center(
            child: Text('Lỗi tải danh sách tác giả!'),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            context.read<AuthorsBloc>().add(AuthorsFetched());
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return AuthorItem(authorElement: state.authors[index]);
              },
              itemCount: state.authors.length,
            ),
          ),
        );
      },
    );
  }
}
