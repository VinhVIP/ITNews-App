import 'package:flutter/material.dart';
import 'package:it_news/presentation/components/menu_item.dart';
import 'package:it_news/presentation/router/app_router.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        MenuItem(
          icon: Icons.tag,
          title: "Tất cả thẻ",
          onPress: () {
            Navigator.of(context).pushNamed(AppRouter.tags);
          },
        ),
        MenuItem(
          icon: Icons.person,
          title: "Tất cả tác giả",
          onPress: () {
            // Navigator.of(context).pushNamed(AppRouter.profile);
          },
        ),
      ],
    );
  }
}
