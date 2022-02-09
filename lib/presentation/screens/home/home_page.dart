import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:it_news/data/models/post.dart';
import 'package:it_news/data/models/post_full.dart';
import 'package:it_news/presentation/router/app_router.dart';
import 'package:it_news/presentation/screens/discover/discover_page.dart';
import 'package:it_news/presentation/screens/home/my_posts.dart';
import 'package:it_news/presentation/screens/home/tab_posts.dart';
import 'package:it_news/presentation/screens/profile/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<HomePage> {
  int _selectedIndex = 0;
  int badge = 2;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

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
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.writePost,
                  arguments: PostFull.empty,
                );
              },
              icon: const Icon(Icons.create_sharp)),
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
                  // leading: Badge(
                  //   badgeColor: Colors.red.shade100,
                  //   elevation: 0,
                  //   position: BadgePosition.topEnd(top: -12, end: -12),
                  //   badgeContent: Text(
                  //     "5",
                  //     style: TextStyle(color: Colors.red.shade900),
                  //   ),
                  //   child: Icon(
                  //     Icons.favorite,
                  //     color: _selectedIndex == 1 ? Colors.pink : Colors.black,
                  //   ),
                  // ),
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
