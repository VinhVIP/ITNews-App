import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:it_news/data/models/post_full.dart';
import 'package:it_news/presentation/screens/comment/comments_page.dart';
import 'package:it_news/presentation/screens/post_detail/expandable_fab.dart';
import 'package:markdown_widget/markdown_widget.dart';

class PostPage extends StatelessWidget {
  const PostPage({Key? key, required this.post}) : super(key: key);
  final PostFull post;

  Widget buildMD() => MarkdownWidget(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        data: post.post.content,
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

  void showComments(context) {
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
              backgroundColor: Colors.green,
              title: Text(post.post.title.trim()),
              floating: false,
              pinned: false,
            )
          ];
        },
        // body: buildMD(),
        body: buildMD(),
      ),
      floatingActionButton: ExpandableFab(
        distance: 100.0,
        children: [
          Column(
            children: [
              Material(
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                color: Colors.green,
                elevation: 4.0,
                child: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    showComments(context);
                  },
                  icon: const Icon(Icons.comment),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                post.post.totalComment.toString(),
                style: const TextStyle(color: Colors.green),
              ),
            ],
          ),
          Column(
            children: [
              Material(
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                color: Colors.green,
                elevation: 4.0,
                child: IconButton(
                  color: Colors.white,
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border_outlined),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                post.post.totalBookmark.toString(),
                style: const TextStyle(color: Colors.green),
              ),
            ],
          ),
          Column(
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
                (post.post.totalVoteUp - post.post.totalVoteDown).toString(),
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
          ),
        ],
      ),
    );
  }
}
