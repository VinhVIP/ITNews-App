import 'package:avatar_view/avatar_view.dart';
import 'package:flutter/material.dart';
import 'package:it_news/data/models/user.dart';
import 'package:it_news/presentation/router/app_router.dart';
import 'package:it_news/presentation/screens/profile/followers_page.dart';
import 'package:it_news/presentation/screens/profile/tags_following_page.dart';

import 'followings_page.dart';

class ProfileDetail extends StatelessWidget {
  const ProfileDetail({Key? key, required this.account}) : super(key: key);
  final User account;

  void showBottomModal(context, widget) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      builder: (context) => widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // physics: const ScrollPhysics(),
      // shrinkWrap: true,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AvatarView(
              radius: 50,
              imagePath: account.avatar,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            "${account.realName} ${account.idRole == 1 ? "(Admin)" : account.idRole == 2 ? "(Mod)" : ""}",
            style: TextStyle(
              color: account.idRole == 1
                  ? Colors.red
                  : account.idRole == 2
                      ? Colors.blue
                      : Colors.green,
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
        ),
        Center(
          child: Text(
            "@${account.accountName}",
            style: const TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 12, top: 10, bottom: 10, right: 6),
          child: Column(
            children: [
              DetailItem(title: 'Email', value: account.email),
              DetailItem(title: 'Ngày sinh', value: account.birth),
              DetailItem(
                  title: 'Giới tính',
                  value: account.gender == 0 ? "Nam" : "Nữ"),
              DetailItem(title: 'Cơ quan', value: account.company),
              DetailItem(title: 'Ngày tham gia', value: account.createDate),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ItemStatistics(
              color: Colors.blue,
              icon: Icons.post_add,
              num: account.totalPost,
              description: "Bài viết",
              onPress: () {
                Navigator.of(context).pushNamed(
                  AppRouter.postsOfAuthor,
                  arguments: account,
                );
              },
            ),
            ItemStatistics(
              color: Colors.green,
              icon: Icons.star,
              num: account.totalVoteUp - account.totalVoteDown,
              description: "Điểm vote",
              onPress: () {},
            ),
            ItemStatistics(
              color: Colors.indigo,
              icon: Icons.remove_red_eye,
              num: account.totalView,
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
              num: account.totalFollower,
              description: "Follower",
              onPress: () {
                showBottomModal(context, FollowersPage(author: account));
              },
            ),
            ItemStatistics(
              color: Colors.orange,
              icon: Icons.person_add_alt_1,
              num: account.totalFollowing,
              description: "Following",
              onPress: () {
                showBottomModal(context, FollowingsPage(author: account));
              },
            ),
            ItemStatistics(
              color: Colors.brown,
              icon: Icons.tag,
              num: account.totalTagFollow,
              description: "Thẻ",
              onPress: () {
                showBottomModal(context, TagsFollowingPage(author: account));
              },
            ),
          ],
        ),
      ],
    );
  }
}

class DetailItem extends StatelessWidget {
  const DetailItem({Key? key, required this.title, required this.value})
      : super(key: key);
  final String title, value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.arrow_right,
          color: Colors.green,
        ),
        SizedBox(
          width: 120,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        value.isNotEmpty
            ? Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            : const Flexible(
                child: Text(
                  '(Trống)',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                  ),
                ),
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
