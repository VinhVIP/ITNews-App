import 'package:avatar_view/avatar_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/data/models/post_full.dart';
import 'package:it_news/data/models/user.dart';
import 'package:it_news/data/repositories/post_repository.dart';
import 'package:it_news/logic/post/bloc/post_bloc.dart';
import 'package:it_news/presentation/screens/comment/comments_page.dart';
import 'package:it_news/presentation/screens/post_detail/expandable_fab.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class PostPage extends StatelessWidget {
  const PostPage({Key? key, required this.post}) : super(key: key);
  final PostFull post;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostBloc(
        postRepository: PostRepository(httpClient: http.Client()),
      )..add(PostFetched(idPost: post.post.idPost)),
      child: const PostPageView(),
    );
  }
}

class PostPageView extends StatelessWidget {
  const PostPageView({Key? key}) : super(key: key);

  Widget buildMD(String data) => MarkdownWidget(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        data: data,
        styleConfig: StyleConfig(imgBuilder: (url, attrs) {
          return CachedNetworkImage(
            imageUrl: url,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          );
        }
            // markdownTheme: MarkdownTheme.darkTheme,
            // preConfig: PreConfig(
            //   language: 'xml',
            // ),
            ),
      );

  void showComments(context, post) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return CommentsPage(post: post);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: BlocBuilder<PostBloc, PostState>(
          buildWhen: (previous, current) {
            return previous.post.post.content != current.post.post.content;
          },
          builder: (context, state) {
            if (state.fetchedStatus == PostFetchedStatus.success) {
              return buildMD(
                "# ${state.post.post.title}\n ${state.post.post.content}",
              );
            } else if (state.fetchedStatus == PostFetchedStatus.failure) {
              return const Center(
                child: Text("Lỗi tải bài viết!"),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state.fetchedStatus == PostFetchedStatus.success) {
            return expandedFloatingActionButton(context);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget expandedFloatingActionButton(BuildContext context) {
    return ExpandableFab(
      distance: 100.0,
      children: [
        BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            return Column(
              children: [
                Material(
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  color: Colors.green,
                  elevation: 4.0,
                  child: IconButton(
                    color: Colors.white,
                    onPressed: () {
                      showComments(context, state.post);
                    },
                    icon: const Icon(Icons.comment),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  state.post.post.totalComment.toString(),
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            );
          },
        ),
        BlocConsumer<PostBloc, PostState>(
          buildWhen: (previous, current) {
            return previous.bookmarkedStatus != current.bookmarkedStatus ||
                previous.post.post.totalBookmark !=
                    current.post.post.totalBookmark;
          },
          listenWhen: (previous, current) {
            return previous.bookmarkedStatus != current.bookmarkedStatus;
          },
          listener: (context, state) {
            String message;
            switch (state.bookmarkedStatus) {
              case PostBookmarkedStatus.bookmarked:
                message = "Thêm bookmark thành công!";
                break;
              case PostBookmarkedStatus.unbookmarked:
                message = "Xóa bookmark thành công!";
                break;
              case PostBookmarkedStatus.failure:
                message = "Có lỗi xảy ra, xin hãy thử lại sau!";
                break;
              default:
                return;
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                duration: const Duration(milliseconds: 1500),
              ),
            );
          },
          builder: (bloc, state) {
            final totalBookmark = state.post.post.totalBookmark;

            if (state.bookmarkedStatus == PostBookmarkedStatus.loading) {
              return BookmarkActionButton(
                totalBookmark: totalBookmark,
                // child: const LoadingIndicator(
                //   indicatorType: Indicator.ballPulse,
                //   strokeWidth: 0.1,
                //   colors: [Colors.orange, Colors.yellow, Colors.blueAccent],
                // ),
                child: LoadingAnimationWidget.threeRotatingDots(
                  color: Colors.yellow,
                  size: 25,
                ),
              );
            }

            final isBookmarked = state.post.post.bookmarkStatus;
            if (isBookmarked) {
              return BookmarkActionButton(
                totalBookmark: totalBookmark,
                child: IconButton(
                  color: Colors.white,
                  onPressed: () => context
                      .read<PostBloc>()
                      .add(PostBookmarkDeleted(state.post.post.idPost)),
                  icon: const Icon(Icons.bookmark_added),
                ),
              );
            } else {
              return BookmarkActionButton(
                totalBookmark: totalBookmark,
                child: IconButton(
                  color: Colors.white,
                  onPressed: () => context
                      .read<PostBloc>()
                      .add(PostBookmarkAdded(state.post.post.idPost)),
                  icon: const Icon(Icons.bookmark_add_outlined),
                ),
              );
            }
          },
        ),
        BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            return Column(
              children: [
                Material(
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  color: Colors.green,
                  elevation: 4.0,
                  child: IconButton(
                    color: Colors.white,
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_circle_up_outlined,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  (state.post.post.totalVoteUp - state.post.post.totalVoteDown)
                      .toString(),
                  style: const TextStyle(color: Colors.green),
                ),
                const SizedBox(height: 5),
                Material(
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  color: Colors.green,
                  elevation: 4.0,
                  child: IconButton(
                    color: Colors.white,
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_drop_down_circle),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class BookmarkActionButton extends StatelessWidget {
  final Widget child;
  final int totalBookmark;

  const BookmarkActionButton({
    Key? key,
    required this.totalBookmark,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          color: Colors.green,
          elevation: 4.0,
          child: SizedBox(width: 48, height: 48, child: child),
        ),
        const SizedBox(height: 5),
        Text(
          "$totalBookmark",
          style: const TextStyle(color: Colors.green),
        ),
      ],
    );
  }
}

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

class ShimmerAuthor extends StatefulWidget {
  const ShimmerAuthor({Key? key}) : super(key: key);

  @override
  _ShimmerAuthorState createState() => _ShimmerAuthorState();
}

class _ShimmerAuthorState extends State<ShimmerAuthor> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white70,
      highlightColor: Colors.green,
      child: Row(
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
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 15,
                    color: Colors.white,
                  ),
                  const Text(" • "),
                  Container(
                    width: 70,
                    height: 15,
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                width: 100,
                height: 15,
                color: Colors.white,
              ),
            ],
          )
        ],
      ),
    );
  }
}
