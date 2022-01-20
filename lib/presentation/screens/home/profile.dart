import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/logic/authen/bloc/authen_bloc.dart';
import 'package:it_news/presentation/router/app_router.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('Logout'),
        onPressed: () {
          BlocProvider.of<AuthenBloc>(context).add(AuthenLogoutRequested());
          Navigator.of(context)
              .pushNamedAndRemoveUntil(AppRouter.login, (route) => false);
        },
      ),
    );
  }
}
