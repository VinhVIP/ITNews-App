import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/logic/post/bloc/post_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FloatingBookmark extends StatelessWidget {
  const FloatingBookmark({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostBloc, PostState>(
      buildWhen: (previous, current) {
        return previous.bookmarkedStatus != current.bookmarkedStatus ||
            previous.post.post.totalBookmark != current.post.post.totalBookmark;
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
