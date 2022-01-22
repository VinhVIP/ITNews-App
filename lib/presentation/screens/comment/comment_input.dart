import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/logic/comment/bloc/comment_bloc.dart';
import 'package:it_news/presentation/screens/comment/comment_reply_detail.dart';

class CommentInput extends StatefulWidget {
  const CommentInput({
    Key? key,
  }) : super(key: key);

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void sendComment() {
    final int idParentComment =
        BlocProvider.of<CommentBloc>(context).state.idParentComment;
    final int idCommentEdit =
        BlocProvider.of<CommentBloc>(context).state.idCommentEdit;

    if (idParentComment != 0) {
      // Trả lời bình luận
      BlocProvider.of<CommentBloc>(context).add(CommentInserted(
        content: commentController.text,
        idParentComment: idParentComment,
      ));
    } else if (idCommentEdit != 0) {
      // Cập nhật bình luận
      BlocProvider.of<CommentBloc>(context).add(CommentUpdated(
        idComment: idCommentEdit,
        newContent: commentController.text,
      ));
    } else {
      // Thêm mới bình luận
      BlocProvider.of<CommentBloc>(context).add(CommentInserted(
        content: commentController.text,
      ));
    }

    commentController.text = "";
    BlocProvider.of<CommentBloc>(context).add(const CommentReplied());
  }

  @override
  Widget build(BuildContext context) {
    // Lắng nghe sự kiện "Sửa bình luận"
    // Nội dung bình luận muốn sửa sẽ được gán vào ô input comment.
    return BlocListener<CommentBloc, CommentState>(
      listenWhen: (previous, current) {
        return current.editContent.isNotEmpty;
      },
      listener: (context, state) {
        commentController.text = state.editContent;
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          elevation: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Column(
              children: [
                const CommentReplyDetail(),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        minLines: 1,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                          fillColor: Colors.black12,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 0.0,
                              style: BorderStyle.none,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          hintText: 'Thêm bình luận...',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: sendComment,
                      icon: const Icon(
                        Icons.send,
                        color: Colors.blue,
                      ),
                      splashRadius: 22.0,
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
