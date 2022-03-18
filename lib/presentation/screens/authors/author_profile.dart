import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/core/utils/utils.dart';
import 'package:it_news/data/models/user.dart';
import 'package:it_news/data/repositories/account_repository.dart';
import 'package:it_news/logic/author/bloc/author_bloc.dart';
import 'package:it_news/presentation/screens/profile/profile_detail.dart';
import 'package:http/http.dart' as http;

class AuthorProfile extends StatelessWidget {
  const AuthorProfile({Key? key, required this.author}) : super(key: key);
  final User author;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tác giả'),
        backgroundColor: Colors.green,
      ),
      body: BlocProvider(
        create: (_) => AuthorBloc(
          accountRepository: AccountRepository(
            httpClient: http.Client(),
          ),
        )..add(AuthorFetched(author.idAccount)),
        child: const AuthorProfileDetail(),
      ),
    );
  }
}

class AuthorProfileDetail extends StatelessWidget {
  const AuthorProfileDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthorBloc, AuthorState>(
      listenWhen: (previous, current) {
        return current.message.isNotEmpty;
      },
      listener: (context, state) {
        return Utils.showMessageDialog(
            context: context, title: "Thông báo", content: state.message);
      },
      builder: (context, state) {
        if (state.fetchedStatus == AuthorFetchedStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            context
                .read<AuthorBloc>()
                .add(AuthorFetched(state.authorElement.author.idAccount));
          },
          child: ListView(
            padding: const EdgeInsets.only(top: 10),
            children: [
              ProfileDetail(authorElement: state.authorElement),
            ],
            // children[]:
          ),
        );
      },
    );
  }
}
