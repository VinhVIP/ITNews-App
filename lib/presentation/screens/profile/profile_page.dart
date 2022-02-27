import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/core/utils/utils.dart';
import 'package:it_news/data/repositories/account_repository.dart';
import 'package:it_news/logic/authen/bloc/authen_bloc.dart';
import 'package:it_news/logic/author/bloc/author_bloc.dart';
import 'package:it_news/logic/authors/models/author_element.dart';
import 'package:it_news/presentation/components/menu_item.dart';
import 'package:it_news/presentation/router/app_router.dart';
import 'package:it_news/presentation/screens/profile/profile_detail.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthorBloc(
        accountRepository: AccountRepository(
          httpClient: http.Client(),
        ),
      )..add(AuthorViewUser(Utils.user)),
      child: const ProfilePageView(),
    );
  }
}

class ProfilePageView extends StatelessWidget {
  const ProfilePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthorBloc, AuthorState>(
      builder: (context, state) {
        if (state.authorElement.author.idAccount == 0) {
          return Container();
        }
        Utils.user = state.authorElement.author;

        return RefreshIndicator(
          onRefresh: () async {
            context.read<AuthorBloc>().add(AuthorFetched(Utils.user.idAccount));
          },
          child: ListView(
            padding: const EdgeInsets.all(6),
            // physics: const ClampingScrollPhysics(),
            // shrinkWrap: true,
            children: [
              ProfileDetail(
                authorElement: AuthorElement(
                    state.authorElement.author, AuthorFollowStatus.success),
              ),
              MenuItem(
                icon: Icons.settings,
                title: "Sửa thông tin cá nhân",
                onPress: () {
                  Navigator.of(context).pushNamed(AppRouter.profile);
                },
              ),
              MenuItem(
                icon: Icons.password,
                title: "Đổi mật khẩu",
                onPress: () {
                  Navigator.of(context).pushNamed(AppRouter.changePass);
                },
              ),
              MenuItem(
                icon: Icons.logout,
                title: "Đăng xuất",
                onPress: () {
                  BlocProvider.of<AuthenBloc>(context)
                      .add(AuthenLogoutRequested());
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRouter.login, (route) => false);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
