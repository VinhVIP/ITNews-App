import 'package:avatar_view/avatar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/core/utils/utils.dart';
import 'package:it_news/data/models/post_full.dart';
import 'package:it_news/logic/posts/bloc/posts_bloc.dart';
import 'package:it_news/presentation/router/app_router.dart';
import 'package:it_news/presentation/screens/tab_posts/tag_chip.dart';

class PostListItem extends StatelessWidget {
  final PostFull post;
  final BuildContext ctx;

  const PostListItem({Key? key, required this.post, required this.ctx})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: InkWell(
          splashColor: Colors.greenAccent,
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Navigator.of(context)
                .pushNamed(AppRouter.post, arguments: post.post.idPost);
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 8, right: 16),
                  child: Column(
                    children: [
                      AvatarView(
                        radius: 25,
                        borderColor: Colors.yellow,
                        avatarType: AvatarType.CIRCLE,
                        backgroundColor: Colors.red,
                        imagePath: post.author.avatar,
                        placeHolder: const Icon(
                          Icons.person,
                          size: 20,
                        ),
                        errorWidget: const Icon(
                          Icons.error,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        (post.post.totalVoteUp - post.post.totalVoteDown > 0
                                ? "+${post.post.totalVoteUp - post.post.totalVoteDown}"
                                : post.post.totalVoteUp -
                                    post.post.totalVoteDown)
                            .toString(),
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.post.title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 26,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return TagChip(tagName: post.tags[index].name);
                          },
                          itemCount: post.tags.length,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                      Text(
                        post.post.content,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 13,
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          rowPostMoreInfo(Icons.remove_red_eye, post.post.view),
                          rowPostMoreInfo(
                              Icons.comment, post.post.totalComment),
                          rowPostMoreInfo(
                              Icons.bookmark, post.post.totalBookmark),
                          IconButton(
                            onPressed: () {
                              showBottomModal(context);
                            },
                            icon: const Icon(
                              Icons.more,
                              color: Colors.blue,
                            ),
                            splashRadius: 15,
                            iconSize: 16,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showBottomModal(context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      builder: (context) {
        List<Widget> actions = [];

        if (Utils.user.idRole <= 2) {
          // N???u l?? moder tr??? l??n

          switch (post.post.status) {
            case 0:
              // C??c b??i vi???t Ch??? ki???m duy???t
              actions.add(sensorship(ctx));
              actions.add(spam(ctx));
              break;
            case 1:
              // C??c b??i vi???t ???? duy???t
              actions.add(spam(ctx));
              break;
            case 2:
              // C??c b??i vi???t spam
              actions.add(sensorship(ctx));
              break;
          }
        }

        if (Utils.user.idAccount == post.author.idAccount) {
          // N???u user l?? t??c gi???
          switch (post.post.access) {
            case 0:
              // Drafts
              actions.add(changeToPublic(ctx));
              actions.add(changeToUnlisted(ctx));
              break;
            case 1:
              // Public
              actions.add(changeToDrafts(ctx));
              actions.add(changeToUnlisted(ctx));
              break;
            case 2:
              // unlisted
              actions.add(changeToDrafts(ctx));
              actions.add(changeToPublic(ctx));
              break;
          }
        }

        // C??c b??i vi???t c??ng khai ho???c ???n link v?? ???? ki???m duy???t th?? c?? th??? bookmark
        // if (post.post.access != 0 && post.post.status == 1) {
        if (post.post.bookmarkStatus) {
          actions.add(deleteBookmark(ctx));
        } else {
          actions.add(bookmark(ctx));
        }
        // }

        return Wrap(
          children: [
            ...actions,
          ],
        );
      },
    );
  }

  Widget sensorship(context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<PostsBloc>(context).add(PostsStatusChanged(
          idPost: post.post.idPost,
          status: 1,
        ));
        Navigator.pop(context);
      },
      child: const ListTile(
        leading: Icon(Icons.sensors, color: Colors.green),
        title: Text("Duy???t b??i vi???t"),
        subtitle: Text("B??i vi???t s??? ???????c duy???t cho m???i ng?????i xem"),
      ),
    );
  }

  Widget spam(context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<PostsBloc>(context).add(PostsStatusChanged(
          idPost: post.post.idPost,
          status: 2,
        ));
        Navigator.pop(context);
      },
      child: const ListTile(
        leading: Icon(Icons.remove_moderator, color: Colors.red),
        title: Text("Chuy???n v??o Spam"),
        subtitle: Text("B??i vi???t kh??ng h???u ??ch"),
      ),
    );
  }

  Widget bookmark(context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<PostsBloc>(context).add(PostsBookmarkAdded(
          post.post.idPost,
        ));
        Navigator.pop(context);
      },
      child: const ListTile(
        leading: Icon(Icons.bookmark_add_outlined),
        title: Text("Th??m bookmark"),
      ),
    );
  }

  Widget deleteBookmark(context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<PostsBloc>(context).add(PostsBookmarkDeleted(
          post.post.idPost,
        ));
        Navigator.pop(context);
      },
      child: const ListTile(
        leading: Icon(Icons.bookmark_remove),
        title: Text("X??a bookmark"),
      ),
    );
  }

  Widget changeToDrafts(context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<PostsBloc>(context).add(PostsAccessChanged(
          idPost: post.post.idPost,
          access: 0,
        ));
        Navigator.pop(context);
      },
      child: const ListTile(
        leading: Icon(Icons.drafts),
        title: Text("Chuy???n sang Nh??p"),
        subtitle:
            Text("Chuy???n b??i vi???t th??nh ri??ng t??, ch??? m??nh b???n c?? th??? xem"),
      ),
    );
  }

  Widget changeToPublic(context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<PostsBloc>(context).add(PostsAccessChanged(
          idPost: post.post.idPost,
          access: 1,
        ));
        Navigator.pop(context);
      },
      child: const ListTile(
        leading: Icon(Icons.public),
        title: Text("Chuy???n sang C??ng khai"),
        subtitle: Text("C??ng khai b??i vi???t c???a b???n cho m???i ng?????i xem"),
      ),
    );
  }

  Widget changeToUnlisted(context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<PostsBloc>(context).add(PostsAccessChanged(
          idPost: post.post.idPost,
          access: 2,
        ));
        Navigator.pop(context);
      },
      child: const ListTile(
        leading: Icon(Icons.hide_source),
        title: Text("Chuy???n sang ???n link"),
        subtitle: Text("Ch??? nh???ng ai c?? li??n k???t m???i ???????c xem"),
      ),
    );
  }

  Widget rowPostMoreInfo(IconData icon, dynamic text) {
    return Wrap(
      children: [
        Icon(
          icon,
          size: 15,
          color: Colors.cyan,
        ),
        const SizedBox(width: 3),
        Text(
          "$text",
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
