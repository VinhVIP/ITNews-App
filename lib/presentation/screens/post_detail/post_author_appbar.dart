import 'package:avatar_view/avatar_view.dart';
import 'package:flutter/material.dart';
import 'package:it_news/data/models/user.dart';
import 'package:it_news/presentation/router/app_router.dart';

class PostAuthorAppBar extends StatelessWidget {
  final User author;
  const PostAuthorAppBar({Key? key, required this.author}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
          padding: EdgeInsets.zero,
          color: Colors.white,
          constraints: const BoxConstraints(),
          splashRadius: 18.0,
        ),
        const SizedBox(width: 10),
        AvatarView(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRouter.authorProfile,
              arguments: author,
            );
          },
          radius: 23,
          borderColor: Colors.yellow,
          avatarType: AvatarType.CIRCLE,
          backgroundColor: Colors.grey,
          imagePath: author.avatar,
          placeHolder: const Icon(
            Icons.person,
            size: 20,
          ),
          errorWidget: const Icon(
            Icons.error,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  author.realName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
                const Text(" • "),
                Text(
                  "@${author.accountName}",
                  style: const TextStyle(
                    color: Colors.white60,
                    fontStyle: FontStyle.italic,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _authorStatictis(
                  Icons.post_add,
                  author.totalPost,
                ),
                _authorStatictis(
                  Icons.star,
                  author.totalVoteUp - author.totalVoteDown,
                ),
                _authorStatictis(
                  Icons.person_add_sharp,
                  author.totalFollower,
                ),
              ],
            )
          ],
        )
      ],
    );
  }

  Widget _authorStatictis(IconData icon, dynamic text) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: 2,
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.yellow,
        ),
        Text(
          "$text",
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
