import 'package:avatar_view/avatar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/core/utils/utils.dart';
import 'package:it_news/logic/authen/bloc/authen_bloc.dart';
import 'package:it_news/presentation/router/app_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(6),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AvatarView(
              radius: 50,
              imagePath: Utils.user.avatar,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Utils.user.realName,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
            const Text(" • "),
            Text(
              "@${Utils.user.accountName}",
              style: const TextStyle(
                color: Colors.black,
                fontStyle: FontStyle.italic,
                fontSize: 17,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ItemStatistics(
              color: Colors.blue,
              icon: Icons.post_add,
              num: Utils.user.totalPost,
              description: "Bài viết",
              onPress: () {},
            ),
            ItemStatistics(
              color: Colors.green,
              icon: Icons.star,
              num: Utils.user.totalVoteUp - Utils.user.totalVoteDown,
              description: "Điểm vote",
              onPress: () {},
            ),
            ItemStatistics(
              color: Colors.indigo,
              icon: Icons.remove_red_eye,
              num: Utils.user.totalView,
              description: "Lượt xem",
              onPress: () {},
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ItemStatistics(
              color: Colors.pink,
              icon: Icons.people,
              num: Utils.user.totalFollower,
              description: "Follower",
              onPress: () {},
            ),
            ItemStatistics(
              color: Colors.orange,
              icon: Icons.person_add_alt_1,
              num: Utils.user.totalFollowing,
              description: "Following",
              onPress: () {},
            ),
            ItemStatistics(
              color: Colors.brown,
              icon: Icons.tag,
              num: Utils.user.totalTagFollow,
              description: "Thẻ",
              onPress: () {},
            ),
          ],
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
          onPress: () {},
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

class ItemStatistics extends StatelessWidget {
  const ItemStatistics({
    Key? key,
    required this.color,
    required this.icon,
    required this.num,
    required this.description,
    required this.onPress,
  }) : super(key: key);

  final Color color;
  final IconData icon;
  final int num;
  final String description;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      width: 75,
      height: 100,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: onPress,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                icon,
                size: 20,
                color: Colors.amberAccent,
              ),
              Text(
                '$num',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem(
      {Key? key, required this.icon, required this.title, this.onPress})
      : super(key: key);

  final IconData icon;
  final String title;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        trailing: const Icon(Icons.keyboard_arrow_right),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        onTap: onPress,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}
