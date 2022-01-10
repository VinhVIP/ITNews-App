import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/data/repositories/account_repository.dart';
import 'package:it_news/logic/authen/bloc/authen_bloc.dart';
import 'package:it_news/presentation/router/app_router.dart';
import 'package:it_news/presentation/screens/splash/splash_page.dart';

class App extends StatelessWidget {
  final AccountRepository authenRepository;

  const App({Key? key, required this.authenRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenRepository,
      child: BlocProvider(
        create: (_) => AuthenBloc(authenRepository: authenRepository),
        child: const MaterialApp(
          initialRoute: AppRouter.init,
          onGenerateRoute: AppRouter.onGenerateRoute,
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenBloc, AuthenState>(
      listener: (context, state) {
        switch (state.status) {
          case AuthenStatus.unauthenticated:
            Navigator.of(context).pushReplacementNamed(AppRouter.login);
            break;
          case AuthenStatus.authenticated:
            Navigator.of(context).pushReplacementNamed(AppRouter.home);
            break;
          default:
            break;
        }
      },
      child: const SplashPage(),
    );
  }
}
