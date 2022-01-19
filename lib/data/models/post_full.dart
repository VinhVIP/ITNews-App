import 'package:equatable/equatable.dart';

import 'package:it_news/data/models/post.dart';
import 'package:it_news/data/models/tag.dart';
import 'package:it_news/data/models/user.dart';

class PostFull extends Equatable {
  static const PostFull empty = PostFull(
    post: Post.empty,
    author: User.empty,
    tags: <Tag>[],
  );

  final Post post;
  final User author;
  final List<Tag> tags;

  const PostFull({
    required this.post,
    required this.author,
    required this.tags,
  });

  @override
  List<Object?> get props => [post, author, tags];

  @override
  String toString() => 'PostFull(post: $post, author: $author, tags: $tags)';

  PostFull copyWith({
    Post? post,
    User? author,
    List<Tag>? tags,
  }) {
    return PostFull(
      post: post ?? this.post,
      author: author ?? this.author,
      tags: tags ?? this.tags,
    );
  }
}
