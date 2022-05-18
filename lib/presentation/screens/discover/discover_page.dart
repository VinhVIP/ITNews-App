import 'package:flutter/material.dart';
import 'package:it_news/core/utils/utils.dart';
import 'package:it_news/presentation/components/menu_item.dart';
import 'package:it_news/presentation/router/app_router.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> menuAdmin = [];
    if (Utils.user.idRole <= 2) {
      menuAdmin.add(
        MyMenuItem(
          icon: Icons.sensors,
          title: "Các bài viết chờ duyệt",
          primaryColor: Colors.lightBlueAccent,
          onPress: () {
            Navigator.pushNamed(context, AppRouter.browse);
          },
        ),
      );

      menuAdmin.add(
        MyMenuItem(
          icon: Icons.remove_moderator_rounded,
          title: "Các bài viết Spam",
          primaryColor: Colors.lightBlueAccent,
          onPress: () {
            Navigator.pushNamed(context, AppRouter.spam);
          },
        ),
      );

      menuAdmin.add(
        MyMenuItem(
          icon: Icons.feedback_rounded,
          title: "Xem các phản hồi",
          primaryColor: Colors.lightBlueAccent,
          onPress: () {
            Navigator.pushNamed(context, AppRouter.feedback);
          },
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        MyMenuItem(
          icon: Icons.tag,
          title: "Tất cả thẻ",
          onPress: () {
            Navigator.of(context).pushNamed(AppRouter.tags);
          },
        ),
        MyMenuItem(
          icon: Icons.person,
          title: "Tất cả tác giả",
          onPress: () {
            Navigator.of(context).pushNamed(AppRouter.authors);
          },
        ),
        ...menuAdmin,
      ],
    );
  }
}
