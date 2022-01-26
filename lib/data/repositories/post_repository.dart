import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:it_news/core/constants/strings.dart';
import 'package:it_news/core/utils/utils.dart';
import 'package:it_news/data/models/comment.dart';
import 'package:it_news/data/models/post.dart';
import 'package:it_news/data/models/post_full.dart';
import 'package:it_news/data/models/tag.dart';
import 'package:it_news/data/models/user.dart';
import 'package:it_news/logic/posts/bloc/posts_bloc.dart';

class PostRepository {
  final http.Client httpClient;

  PostRepository({required this.httpClient});

  Future<List<PostFull>?> getPosts({
    required PostType type,
    required int page,
    int idTag = 0,
    idAccountAuthor = 0,
  }) async {
    late final Uri url;
    switch (type) {
      case PostType.newest:
        url = Uri.parse(Strings.baseURL + "post/newest?page=$page");
        break;
      case PostType.following:
        url = Uri.parse(Strings.baseURL + "post/following?page=$page");
        break;
      case PostType.trending:
        url = Uri.parse(Strings.baseURL + "post/trending?page=$page");
        break;
      case PostType.postsOfTag:
        url = Uri.parse(Strings.baseURL + "tag/$idTag/posts?page=$page");
        break;
      case PostType.postsOfAuthor:
        url = Uri.parse(
            Strings.baseURL + "account/$idAccountAuthor/posts?page=$page");
        break;
    }

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List listPosts = body['data'];
      final List<PostFull> list = listPosts
          .map((data) => PostFull(
                post: Post.fromMap(data['post']),
                author: User.fromMap(data['author']),
                tags: (data['tags'] as List)
                    .map((tag) => Tag.fromMap(tag))
                    .toList(),
              ))
          .toList();
      return list;
    }
  }

  Future<PostFull?> getPost(int idPost) async {
    final url = Uri.parse(Strings.baseURL + "post/$idPost");
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final PostFull post = PostFull(
        post: Post.fromMap(body['data']['post']),
        author: User.fromMap(body['data']['author']),
        tags: (body['data']['tags'] as List)
            .map((tag) => Tag.fromMap(tag))
            .toList(),
      );
      return post;
    }
  }

  Future<http.Response> addBookmark(int idPost) async {
    final url = Uri.parse(Strings.baseURL + "bookmark/$idPost");
    var response = await http.post(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });
    return response;
  }

  Future<http.Response> deleteBookmark(int idPost) async {
    final url = Uri.parse(Strings.baseURL + "bookmark/$idPost");
    var response = await http.delete(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });
    return response;
  }

  Future<http.Response> addVote(int idPost, int voteType) async {
    final url = Uri.parse(Strings.baseURL + "vote/$idPost/$voteType");
    var response = await http.post(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });
    return response;
  }

  Future<http.Response> deleteVote(int idPost) async {
    final url = Uri.parse(Strings.baseURL + "vote/$idPost");
    var response = await http.delete(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });
    return response;
  }

  Future<int> getTotalVoteUp(int idPost) async {
    final url = Uri.parse(Strings.baseURL + "post/$idPost/voteup");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final int mark = body['data']['total'];
      return mark;
    }
    return 0;
  }

  Future<int> getTotalVoteDown(int idPost) async {
    final url = Uri.parse(Strings.baseURL + "post/$idPost/votedown");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final int mark = body['data']['total'];
      return mark;
    }
    return 0;
  }

  Future<List<Comment>?> getCommentsOfPost(int idPost) async {
    final url = Uri.parse(Strings.baseURL + "post/$idPost/comment");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List<Comment> list = (body['data'] as List)
          .map((comment) => Comment.fromMap(comment))
          .toList();

      list.sort((a, b) {
        return -Utils.compareDatetime(
            "${a.day}-${a.time}", "${b.day}-${b.time}");
      });

      List<Comment> main = [];
      for (Comment cmt in list) {
        if (cmt.idCommentParent == cmt.idComment || cmt.idCommentParent == 0) {
          main.add(cmt);
        }
      }

      for (Comment cmt in list) {
        if (cmt.idCommentParent != 0 && cmt.idComment != cmt.idCommentParent) {
          for (Comment parent in main) {
            if (parent.idComment == cmt.idCommentParent) {
              parent.replies.add(cmt);
            }
          }
        }
      }

      return main;
    }
  }

  Future<Comment?> insertComment(int idPost, String comment) async {
    final url = Uri.parse(Strings.baseURL + "post/$idPost/comment");
    var response = await http.post(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    }, body: {
      'content': comment,
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      Comment comment = Comment.fromMap(body['data']);
      return comment;
    }
  }

  Future<Comment?> insertReplyComment(
      int idPost, int idParentComment, String comment) async {
    final url = Uri.parse(
        Strings.baseURL + "post/$idPost/comment/$idParentComment/reply");
    var response = await http.post(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    }, body: {
      'content': comment,
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      Comment comment = Comment.fromMap(body['data']);
      return comment;
    }
  }

  Future<http.Response> changeCommentStatus(
      int idPost, int idComment, int commentStatus) async {
    final url = Uri.parse(Strings.baseURL +
        "post/$idPost/comment/$idComment/status/$commentStatus");
    var response = await http.put(url, headers: {
      'Authorization': 'Bearer ${Strings.accessToken}',
    });
    return response;
  }

  Future<http.Response> updateComment(
      int idPost, int idComment, String newContent) async {
    final url =
        Uri.parse(Strings.baseURL + "post/$idPost/comment/$idComment/update");
    var response = await http.put(
      url,
      headers: {'Authorization': 'Bearer ${Strings.accessToken}'},
      body: {'content': newContent},
    );
    return response;
  }

  Future<http.Response> deleteComment(int idPost, int idComment) async {
    final url =
        Uri.parse(Strings.baseURL + "post/$idPost/comment/$idComment/delete");
    var response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer ${Strings.accessToken}'},
    );
    return response;
  }
}
