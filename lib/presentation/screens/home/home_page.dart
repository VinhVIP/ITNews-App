import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:it_news/logic/authen/bloc/authen_bloc.dart';
import 'package:it_news/presentation/router/app_router.dart';
import 'package:it_news/presentation/screens/home/profile.dart';
import 'package:it_news/presentation/screens/home/tab_posts.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: const Text('Home')),
//         body:

// Center(
//   child: Column(
//     mainAxisSize: MainAxisSize.min,
//     children: <Widget>[
//       Builder(
//         builder: (context) {
//           final userId = context.select(
//             (AuthenBloc bloc) => bloc.state.user.idAccount,
//           );
//           return Text('ID Account: $userId');
//         },
//       ),
//       ElevatedButton(
//         child: const Text('Logout'),
//         onPressed: () {
//           context.read<AuthenBloc>().add(AuthenLogoutRequested());
//           Navigator.of(context)
//               .pushNamedAndRemoveUntil(AppRouter.login, (route) => false);
//         },
//       ),
//     ],
//   ),
// ),
//         );
//   }
// }

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
    const Text(
      'Likes',
      style: optionStyle,
    ),
    const Text(
      'Search',
      style: optionStyle,
    ),
    const Profile(),
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
          IconButton(onPressed: () {}, icon: const Icon(Icons.create_sharp)),
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
              tabs: [
                const GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.favorite,
                  text: 'Likes',
                  leading: Badge(
                    badgeColor: Colors.red.shade100,
                    elevation: 0,
                    position: BadgePosition.topEnd(top: -12, end: -12),
                    badgeContent: Text(
                      "5",
                      style: TextStyle(color: Colors.red.shade900),
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: _selectedIndex == 1 ? Colors.pink : Colors.black,
                    ),
                  ),
                ),
                const GButton(
                  icon: Icons.search,
                  text: 'Search',
                ),
                const GButton(
                  icon: Icons.person,
                  text: 'Profile',
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
