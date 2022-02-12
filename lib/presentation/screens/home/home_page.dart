import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:it_news/data/models/post_full.dart';
import 'package:it_news/data/repositories/notification_repository.dart';
import 'package:it_news/logic/notification/bloc/notification_bloc.dart';
import 'package:it_news/presentation/router/app_router.dart';
import 'package:it_news/presentation/screens/discover/discover_page.dart';
import 'package:it_news/presentation/screens/home/my_posts.dart';
import 'package:it_news/presentation/screens/home/tab_posts.dart';
import 'package:it_news/presentation/screens/profile/profile_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<HomePage> {
  int _selectedIndex = 0;
  int badge = 2;

  static final List<Widget> _widgetOptions = <Widget>[
    const TabPosts(),
    const DiscoverPage(),
    const MyPosts(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 5,
        title: const Text('IT News'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRouter.search);
              },
              icon: const Icon(Icons.search)),
          const NotifyAction(),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRouter.writePost,
                arguments: PostFull.empty,
              );
            },
            icon: const Icon(Icons.create_sharp),
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.green,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 300),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black54,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Trang chủ',
                ),
                GButton(
                  icon: Icons.all_inclusive,
                  text: 'Khám phá',
                ),
                GButton(
                  icon: Icons.post_add,
                  text: 'Của tôi',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Cá nhân',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

class NotifyAction extends StatelessWidget {
  const NotifyAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return NotificationBloc(NotificationRepository(http.Client()))
          ..add(NotificationCount());
      },
      child: const NotifyItem(),
    );
  }
}

class NotifyItem extends StatelessWidget {
  const NotifyItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        return Badge(
          badgeColor: Colors.amber,
          elevation: 0,
          position: BadgePosition.topEnd(top: 6, end: 4),
          badgeContent: Text(
            "${state.countUnreadNotification}",
            style: const TextStyle(color: Colors.white),
          ),
          child: IconButton(
            onPressed: () async {
              final countNotification = await Navigator.pushNamed(
                context,
                AppRouter.notification,
              ) as int;

              if (countNotification != -1) {
                context
                    .read<NotificationBloc>()
                    .add(NotificationCountUpdated(countNotification));
              }
            },
            icon: const Icon(
              Icons.notifications,
            ),
          ),
        );
      },
    );
  }
}
