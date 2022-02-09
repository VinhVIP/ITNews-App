import 'package:flutter/material.dart';
import 'package:it_news/data/models/post_full.dart';
import 'package:it_news/presentation/screens/post_detail/markdown_viewer.dart';

class PreviewPost extends StatelessWidget {
  const PreviewPost({Key? key, required this.postFull}) : super(key: key);
  final PostFull postFull;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Xem trước"),
      ),
      body: MarkdownViewer(
        data: "# ${postFull.post.title}\n ${postFull.post.content}",
      ),
    );
  }
}
