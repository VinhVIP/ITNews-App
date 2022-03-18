import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/data/repositories/account_repository.dart';
import 'package:it_news/logic/signup/bloc/signup_bloc.dart';
import 'package:it_news/presentation/screens/signup/signup_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xffd6ff7f), Color(0xff00b3cc)],
              ),
            ),
            child: BlocProvider(
              create: (context) {
                return SignupBloc(
                  accountRepository:
                      RepositoryProvider.of<AccountRepository>(context),
                );
              },
              child: const SignupForm(),
            ),
          ),
        ),
      ),
    );
  }
}
