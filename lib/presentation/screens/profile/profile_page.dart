import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/core/utils/utils.dart';
import 'package:it_news/logic/authen/bloc/authen_bloc.dart';
import 'package:it_news/presentation/components/menu_item.dart';
import 'package:it_news/presentation/router/app_router.dart';
import 'package:it_news/presentation/screens/profile/profile_detail.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(6),
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      children: [
        ProfileDetail(account: Utils.user),
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
            BlocProvider.of<AuthenBloc>(context).add(AuthenLogoutRequested());
            Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRouter.login, (route) => false);
          },
        ),
      ],
    );
  }
}
