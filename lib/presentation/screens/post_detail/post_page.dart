import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/core/utils/utils.dart';
import 'package:it_news/data/models/post.dart';
import 'package:it_news/data/models/post_full.dart';
import 'package:it_news/data/repositories/post_repository.dart';
import 'package:it_news/logic/post/bloc/post_bloc.dart';
import 'package:it_news/presentation/router/app_router.dart';
import 'package:it_news/presentation/screens/post_detail/expandable_fab.dart';
import 'package:http/http.dart' as http;

import 'floating_bookmark.dart';
import 'floating_comment.dart';
import 'floating_vote.dart';
import 'post_author_appbar.dart';
import 'post_content.dart';
import 'shimmer_author.dart';

class PostPage extends StatelessWidget {
  const PostPage({
    Key? key,
    required this.idPost,
  }) : super(key: key);

  final int idPost;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostBloc(
        postRepository: PostRepository(httpClient: http.Client()),
      )..add(PostFetched(idPost: idPost)),
      child: const PostPageView(),
    );
  }
}

class PostPageView extends StatelessWidget {
  const PostPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listenWhen: (previous, current) {
        return current.message.isNotEmpty;
      },
      listener: (context, state) {
        Utils.showMessageDialog(
          context: context,
          title: "Thông báo",
          content: state.message,
        );
      },
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: false,
                pinned: false,
                elevation: 4,
                forceElevated: true,
                automaticallyImplyLeading: false,
                toolbarHeight: 60,
                backgroundColor: Colors.green,
                title: BlocBuilder<PostBloc, PostState>(
                  buildWhen: (previous, current) {
                    return previous.post.author != current.post.author;
                  },
                  builder: (context, state) {
                    if (state.fetchedStatus == PostFetchedStatus.success) {
                      return PostAuthorAppBar(author: state.post.author);
                    }
                    return const ShimmerAuthor();
                  },
                ),
              ),
            ];
          },
          body: const PostContent(),
        ),
        floatingActionButton: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state.fetchedStatus == PostFetchedStatus.success) {
              return expandedFloatingActionButton(context, state.post);
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget expandedFloatingActionButton(BuildContext context, PostFull postFull) {
    List<Widget> actions = [];
    if (Utils.user.idRole <= 2 ||
        Utils.user.idAccount == postFull.post.idAccount) {
      actions.add(
        Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          color: Colors.blue,
          elevation: 4.0,
          child: SizedBox(
            width: 48,
            height: 48,
            child: IconButton(
                onPressed: () {
                  showBottomModal(context, postFull);
                },
                icon: const Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                )),
          ),
        ),
      );
    }

    actions.add(const FloatingComment());
    actions.add(const FloatingBookmark());
    actions.add(const FloatingVote());

    return ExpandableFab(
      distance: 100.0,
      children: [
        ...actions,
      ],
    );
  }

  void showBottomModal(context, PostFull postFull) {
    List<Widget> actions = [];

    // Quản trị dành cho Moder, Admin
    if (Utils.user.idRole <= 2) {
      switch (postFull.post.status) {
        case 0:
          actions.add(const Center(
            child: Text(
              "Bài viết này chưa được kiểm duyệt",
              style: TextStyle(color: Colors.grey),
            ),
          ));

          actions.add(showPostDetail(context, postFull));
          actions.add(sensorship(context, postFull.post));
          actions.add(spam(context, postFull.post));
          break;
        case 1:
          actions.add(const Center(
            child: Text(
              "Bài viết này đã được kiểm duyệt",
              style: TextStyle(color: Colors.green),
            ),
          ));

          actions.add(showPostDetail(context, postFull));
          actions.add(spam(context, postFull.post));
          break;
        case 2:
          actions.add(const Center(
            child: Text(
              "Bài viết này là Spam",
              style: TextStyle(color: Colors.red),
            ),
          ));

          actions.add(showPostDetail(context, postFull));
          actions.add(sensorship(context, postFull.post));
          break;
      }
    }

    // Quản trị dành cho tác giả
    if (postFull.post.idAccount == Utils.user.idAccount) {
      actions.add(editPost(context, postFull));

      switch (postFull.post.access) {
        case 0:
          actions.add(changeToPublic(context, postFull.post));
          actions.add(changeToUnlisted(context, postFull.post));
          break;
        case 1:
          actions.add(changeToDrafts(context, postFull.post));
          actions.add(changeToUnlisted(context, postFull.post));
          break;
        case 2:
          actions.add(changeToDrafts(context, postFull.post));
          actions.add(changeToPublic(context, postFull.post));
          break;
      }
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Wrap(
            children: [
              ...actions,
            ],
          ),
        );
      },
    );
  }

  Widget showPostDetail(context, PostFull post) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Wrap(
                  direction: Axis.vertical,
                  spacing: 3.0,
                  children: [
                    itemDetail(
                      title: "Thời gian tạo :",
                      content:
                          "${post.post.dayCreated} - ${post.post.timeCreated}",
                    ),
                    itemDetail(
                      title: "Sửa lần cuối :",
                      content:
                          "${post.post.dayLastModified} - ${post.post.timeLastModified}",
                    ),
                    itemDetail(
                      title: "Số lượt xem :",
                      content: "${post.post.view}",
                    ),
                    itemDetail(
                        title: "Điểm vote :",
                        widgetContent: Row(
                          children: [
                            Text(
                              "${post.post.totalVoteUp - post.post.totalVoteDown}  ",
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 15),
                            ),
                            const Text("("),
                            Text("${post.post.totalVoteUp}"),
                            const Icon(
                              Icons.arrow_upward,
                              size: 15,
                              color: Colors.green,
                            ),
                            const Text(
                              " ~ ",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text("${post.post.totalVoteDown}"),
                            const Icon(
                              Icons.arrow_downward,
                              size: 15,
                              color: Colors.red,
                            ),
                            const Text(")"),
                          ],
                        )),
                    itemDetail(
                      title: "Số bookmark :",
                      content: "${post.post.totalBookmark}",
                    ),
                    itemDetail(
                      title: "Số bình luận :",
                      content: "${post.post.totalComment}",
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: const ListTile(
        leading: SizedBox(
          child: Icon(
            Icons.info,
            color: Colors.green,
          ),
          height: double.infinity,
        ),
        title: Text("Chi tiết bài viết"),
      ),
    );
  }

  Widget itemDetail(
      {required String title, String? content, Widget? widgetContent}) {
    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(
            title,
            style: const TextStyle(color: Colors.black, fontSize: 15),
          ),
        ),
        if (widgetContent != null) ...[
          widgetContent
        ] else ...[
          Text(
            content!,
            style: const TextStyle(color: Colors.black54, fontSize: 15),
          )
        ],
      ],
    );
  }

  Widget editPost(context, PostFull post) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, AppRouter.writePost, arguments: post);
      },
      child: const ListTile(
        leading: SizedBox(
          child: Icon(Icons.edit, color: Colors.green),
          height: double.infinity,
        ),
        title: Text("Chỉnh sửa bài viết"),
      ),
    );
  }

  Widget changeToDrafts(context, Post post) {
    return InkWell(
      onTap: () {
        BlocProvider.of<PostBloc>(context)
            .add(PostAccessChanged(idPost: post.idPost, access: 0));
        Navigator.pop(context);
      },
      child: const ListTile(
        leading: SizedBox(
          child: Icon(Icons.drafts),
          height: double.infinity,
        ),
        title: Text("Chuyển sang Nháp"),
        subtitle:
            Text("Chuyển bài viết thành riêng tư, chỉ mình bạn có thể xem"),
      ),
    );
  }

  Widget changeToPublic(context, Post post) {
    return InkWell(
      onTap: () {
        BlocProvider.of<PostBloc>(context)
            .add(PostAccessChanged(idPost: post.idPost, access: 1));
        Navigator.pop(context);
      },
      child: const ListTile(
        leading: SizedBox(
          child: Icon(Icons.public),
          height: double.infinity,
        ),
        title: Text("Chuyển sang Công khai"),
        subtitle: Text("Công khai bài viết của bạn cho mọi người xem"),
      ),
    );
  }

  Widget changeToUnlisted(context, Post post) {
    return InkWell(
      onTap: () {
        BlocProvider.of<PostBloc>(context)
            .add(PostAccessChanged(idPost: post.idPost, access: 1));
        Navigator.pop(context);
      },
      child: const ListTile(
        leading: SizedBox(
          child: Icon(Icons.hide_source),
          height: double.infinity,
        ),
        title: Text("Chuyển sang Ẩn link"),
        subtitle: Text("Chỉ những ai có liên kết mới được xem"),
      ),
    );
  }

  Widget spam(context, Post post) {
    return InkWell(
      onTap: () {
        BlocProvider.of<PostBloc>(context)
            .add(PostStatusChanged(idPost: post.idPost, status: 2));
        Navigator.pop(context);
      },
      child: const ListTile(
        leading: SizedBox(
          child: Icon(Icons.remove_moderator, color: Colors.red),
          height: double.infinity,
        ),
        title: Text("Chuyển vào Spam"),
        subtitle: Text("Bài viết không hữu ích"),
      ),
    );
  }

  Widget sensorship(context, Post post) {
    return InkWell(
      onTap: () {
        BlocProvider.of<PostBloc>(context)
            .add(PostStatusChanged(idPost: post.idPost, status: 1));
        Navigator.pop(context);
      },
      child: const ListTile(
        leading: SizedBox(
          child: Icon(Icons.sensors, color: Colors.green),
          height: double.infinity,
        ),
        title: Text("Duyệt bài viết"),
        subtitle: Text("Bài viết sẽ được duyệt cho mọi người xem"),
      ),
    );
  }
}
