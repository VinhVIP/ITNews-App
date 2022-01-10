import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/data/repositories/account_repository.dart';
import 'package:http/http.dart' as http;
import 'app.dart';
import 'app_bloc_observer.dart';

Future<void> main() async {
  BlocOverrides.runZoned(
    () => runApp(
      App(
        authenRepository: AccountRepository(
          httpClient: http.Client(),
        ),
      ),
    ),
    blocObserver: AppBlocObserver(),
  );
}
