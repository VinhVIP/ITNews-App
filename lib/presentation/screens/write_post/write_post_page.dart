import 'package:flutter/material.dart';
import 'package:it_news/core/utils/utils.dart';
import 'package:it_news/data/models/post.dart';
import 'package:it_news/data/models/post_full.dart';
import 'package:it_news/presentation/router/app_router.dart';

class WritePostPage extends StatefulWidget {
  const WritePostPage({Key? key, required this.postFull}) : super(key: key);
  final PostFull postFull;

  @override
  State<WritePostPage> createState() => _WritePostPageState();
}

class _WritePostPageState extends State<WritePostPage> {
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerContent = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controllerTitle.text = widget.postFull.post.title;
    _controllerContent.text = widget.postFull.post.content;
  }

  @override
  void dispose() {
    super.dispose();
    _controllerTitle.dispose();
    _controllerContent.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.postFull.post.idPost == 0 ? "Viết bài" : "Chỉnh sửa bài viết",
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.previewPost,
                  arguments: getWritePost(),
                );
              },
              icon: const Icon(Icons.preview)),
        ],
      ),
      body: formPost(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_controllerTitle.text.trim().isEmpty ||
              _controllerContent.text.trim().isEmpty) {
            Utils.showSnackbar(
              context: context,
              message: "Tiêu đề và nội dung không được bỏ trống!",
            );
            return;
          }
          final res = await Navigator.pushNamed(
            context,
            AppRouter.accessAndTags,
            arguments: getWritePost(),
          );

          if (Utils.isEdited) Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_right_alt),
      ),
    );
  }

  PostFull getWritePost() {
    final Post post = widget.postFull.post.copyWith(
      title: _controllerTitle.text.trim(),
      content: _controllerContent.text.trim(),
    );
    return widget.postFull.copyWith(post: post);
  }

  Widget formPost() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: _controllerTitle,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: "Tiêu đề",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: TextField(
              controller: _controllerContent,
              maxLines: null,
              expands: true,
              keyboardType: TextInputType.multiline,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: "Nội dung...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
