import 'package:avatar_view/avatar_view.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/data/models/comment.dart';
import 'package:it_news/logic/comment/bloc/comment_bloc.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({Key? key, required this.comment}) : super(key: key);
  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Comment cha
          CommentListItem(comment: comment),
          // Danh sách các phản hồi của bình luận cha
          comment.replies.isNotEmpty
              ? ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToExpand: true,
                      hasIcon: true,
                      iconPlacement: ExpandablePanelIconPlacement.left,
                      useInkWell: false,
                      iconPadding: EdgeInsets.only(left: 50),
                    ),
                    header: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Xem thêm ${comment.replies.length} phản hồi",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    collapsed: Container(),
                    expanded: Column(
                      children: [
                        ...commentReplies(),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  List<Widget> commentReplies() {
    final List<Widget> list = [];
    for (Comment cmt in comment.replies) {
      list.add(
        Container(
          padding: const EdgeInsets.only(left: 40),
          child: CommentListItem(comment: cmt),
        ),
      );
    }
    return list;
  }
}

class CommentListItem extends StatelessWidget {
  const CommentListItem({Key? key, required this.comment}) : super(key: key);
  final Comment comment;

  // Kiểm tra `comment` có phải là comment cha hay không?
  bool isParent() {
    return comment.idComment == comment.idCommentParent ||
        comment.idCommentParent == 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 4, bottom: 0, left: 4, right: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          avatar(),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                author(),
                const SizedBox(height: 3),
                Text(comment.content.trim()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    datetime(),
                    const SizedBox(width: 6),
                    ...actions(context),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget avatar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: AvatarView(
        radius: 20,
        borderColor: Colors.yellow,
        avatarType: AvatarType.CIRCLE,
        backgroundColor: Colors.red,
        imagePath: comment.avatar,
        placeHolder: const Icon(
          Icons.person,
          size: 20,
        ),
        errorWidget: const Icon(
          Icons.error,
          size: 20,
        ),
      ),
    );
  }

  Widget author() {
    return Row(
      children: [
        Text(
          comment.realName,
          style:
              const TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
        ),
        const Text(" • "),
        Text(
          "@${comment.accountName}",
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget datetime() {
    return Text(
      "${comment.day} - ${comment.time}",
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 13,
      ),
    );
  }

  List<Widget> actions(context) {
    List<Widget> widgets = [];

    if (isParent()) {
      widgets.add(
        _CommentsActionButton(
          child: const Text('Trả lời'),
          onPressed: () {
            BlocProvider.of<CommentBloc>(context).add(
              CommentReplied(
                idParentComment: comment.idComment,
                realNameAccountParent: comment.realName,
              ),
            );
          },
        ),
      );
    }

    widgets.add(
      _CommentsActionButton(
        child: const Text('Ẩn'),
        onPressed: () {},
      ),
    );

    widgets.add(
      _CommentsActionButton(
        child: const Text(
          "Xóa",
          style: TextStyle(color: Colors.red),
        ),
        onPressed: () {},
      ),
    );

    return widgets;
  }
}

class _CommentsActionButton extends StatelessWidget {
  const _CommentsActionButton({Key? key, required this.child, this.onPressed})
      : super(key: key);

  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: child,
    );
  }
}
