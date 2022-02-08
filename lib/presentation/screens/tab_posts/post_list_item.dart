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
            Navigator.of(context).pushNamed(AppRouter.post, arguments: post);
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
        if (Utils.user.idAccount == post.author.idAccount) {
          // Nếu user là tác giả
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

        if (post.post.bookmarkStatus) {
          actions.add(deleteBookmark(ctx));
        } else {
          actions.add(bookmark(ctx));
        }

        return Wrap(
          children: [
            ...actions,
          ],
        );
      },
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
        title: Text("Thêm bookmark"),
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
        title: Text("Xóa bookmark"),
      ),
    );
  }

  Widget changeToDrafts(context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<PostsBloc>(context).add(PostAccessChanged(
          idPost: post.post.idPost,
          access: 0,
        ));
        Navigator.pop(context);
      },
      child: const ListTile(
        leading: Icon(Icons.drafts),
        title: Text("Chuyển sang Nháp"),
      ),
    );
  }

  Widget changeToPublic(context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<PostsBloc>(context).add(PostAccessChanged(
          idPost: post.post.idPost,
          access: 1,
        ));
        Navigator.pop(context);
      },
      child: const ListTile(
        leading: Icon(Icons.public),
        title: Text("Chuyển sang Công khai"),
      ),
    );
  }

  Widget changeToUnlisted(context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<PostsBloc>(context).add(PostAccessChanged(
          idPost: post.post.idPost,
          access: 2,
        ));
        Navigator.pop(context);
      },
      child: const ListTile(
        leading: Icon(Icons.hide_source),
        title: Text("Chuyển sang Ẩn link"),
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
