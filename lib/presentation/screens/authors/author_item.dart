import 'package:avatar_view/avatar_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/logic/authors/bloc/authors_bloc.dart';
import 'package:it_news/logic/authors/models/author_element.dart';
import 'package:it_news/presentation/router/app_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AuthorItem extends StatelessWidget {
  const AuthorItem({Key? key, required this.authorElement}) : super(key: key);

  final AuthorElement authorElement;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRouter.authorProfile,
              arguments: authorElement.author);
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: CachedNetworkImage(
                      imageUrl: authorElement.author.avatar,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Icon(Icons.person),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  // AvatarView(
                  //   radius: 28,
                  //   avatarType: AvatarType.CIRCLE,
                  //   backgroundColor: Colors.red,
                  //   imagePath: authorElement.author.avatar,
                  //   placeHolder: const Icon(
                  //     Icons.person,
                  //     size: 20,
                  //   ),
                  // ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authorElement.author.realName,
                        style: TextStyle(
                          color: authorElement.author.idRole == 1
                              ? Colors.red
                              : authorElement.author.idRole == 2
                                  ? Colors.blue
                                  : Colors.green,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '@${authorElement.author.accountName}',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 3),
                      statisticAuthor(),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (authorElement.followStatus ==
                      AuthorFollowStatus.loading) {
                    return;
                  }
                  if (authorElement.author.followStatus) {
                    BlocProvider.of<AuthorsBloc>(context)
                        .add(AuthorUnFollowed(authorElement.author.idAccount));
                  } else {
                    BlocProvider.of<AuthorsBloc>(context)
                        .add(AuthorFollowed(authorElement.author.idAccount));
                  }
                },
                child: authorElement.followStatus == AuthorFollowStatus.loading
                    ? LoadingAnimationWidget.horizontalRotatingDots(
                        color: Colors.yellow,
                        size: 25,
                      )
                    : Text(
                        authorElement.author.followStatus
                            ? "Bỏ theo dõi"
                            : "Theo dõi",
                      ),
                style: ElevatedButton.styleFrom(
                  primary: authorElement.author.followStatus
                      ? Colors.red
                      : Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget statisticAuthor() {
    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.post_add,
              size: 18,
              color: Colors.cyan,
            ),
            const SizedBox(width: 3),
            Text('${authorElement.author.totalPost}'),
          ],
        ),
        const SizedBox(width: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.star,
              size: 18,
              color: Colors.cyan,
            ),
            const SizedBox(width: 3),
            Text(
                '${authorElement.author.totalVoteUp - authorElement.author.totalVoteDown}'),
          ],
        ),
        const SizedBox(width: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.people,
              size: 18,
              color: Colors.cyan,
            ),
            const SizedBox(width: 3),
            Text('${authorElement.author.totalFollower}'),
          ],
        ),
      ],
    );
  }
}
