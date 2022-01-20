import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

class MarkdownViewer extends StatelessWidget {
  const MarkdownViewer({Key? key, required this.data}) : super(key: key);
  final String data;

  @override
  Widget build(BuildContext context) {
    return MarkdownWidget(
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
  }
}
