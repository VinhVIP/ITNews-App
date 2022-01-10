import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/data/repositories/account_repository.dart';
import 'package:it_news/logic/login/bloc/login_bloc.dart';

import 'login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  colors: [Colors.greenAccent, Colors.green]),
            ),
            child: BlocProvider(
              create: (context) {
                return LoginBloc(
                  authenRepository:
                      RepositoryProvider.of<AccountRepository>(context),
                );
              },
              child: const LoginForm(),
            ),
          ),
        ),
      ),
    );
  }
}
