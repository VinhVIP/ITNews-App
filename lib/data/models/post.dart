import 'dart:convert';

import 'package:equatable/equatable.dart';

class Post extends Equatable {
  static const Post empty = Post();

  final int idPost;
  final int idAccount;
  final String title;
  final String content;
  final String dayCreated;
  final String timeCreated;
  final int status;
  final int access;
  final bool bookmarkStatus;
  final int view;
  final int totalComment;
  final int totalBookmark;
  final int totalVoteUp;
  final int totalVoteDown;

  const Post({
    this.idPost = 0,
    this.idAccount = 0,
    this.title = "",
    this.content = "",
    this.dayCreated = "",
    this.timeCreated = "",
    this.status = -1,
    this.access = -1,
    this.bookmarkStatus = false,
    this.view = 0,
    this.totalComment = 0,
    this.totalBookmark = 0,
    this.totalVoteUp = 0,
    this.totalVoteDown = 0,
  });

  @override
  List<Object> get props {
    return [
      idPost,
      idAccount,
      title,
      content,
      dayCreated,
      timeCreated,
      status,
      access,
      bookmarkStatus,
      view,
      totalComment,
      totalBookmark,
      totalVoteUp,
      totalVoteDown,
    ];
  }

  Post copyWith({
    int? idPost,
    int? idAccount,
    String? title,
    String? content,
    String? dayCreated,
    String? timeCreated,
    int? status,
    int? access,
    bool? bookmarkStatus,
    int? view,
    int? totalComment,
    int? totalBookmark,
    int? totalVoteUp,
    int? totalVoteDown,
  }) {
    return Post(
      idPost: idPost ?? this.idPost,
      idAccount: idAccount ?? this.idAccount,
      title: title ?? this.title,
      content: content ?? this.content,
      dayCreated: dayCreated ?? this.dayCreated,
      timeCreated: timeCreated ?? this.timeCreated,
      status: status ?? this.status,
      access: access ?? this.access,
      bookmarkStatus: bookmarkStatus ?? this.bookmarkStatus,
      view: view ?? this.view,
      totalComment: totalComment ?? this.totalComment,
      totalBookmark: totalBookmark ?? this.totalBookmark,
      totalVoteUp: totalVoteUp ?? this.totalVoteUp,
      totalVoteDown: totalVoteDown ?? this.totalVoteDown,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_post': idPost,
      'id_account': idAccount,
      'title': title,
      'content': content,
      'day_created': dayCreated,
      'time_created': timeCreated,
      'status': status,
      'access': access,
      'bookmark_status': bookmarkStatus,
      'view': view,
      'total_comment': totalComment,
      'total_bookmark': totalBookmark,
      'total_vote_up': totalVoteUp,
      'total_vote_down': totalVoteDown,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      idPost: map['id_post']?.toInt() ?? 0,
      idAccount: map['id_account']?.toInt() ?? 0,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      dayCreated: map['day_created'] ?? '',
      timeCreated: map['time_created'] ?? '',
      status: map['status']?.toInt() ?? 0,
      access: map['access']?.toInt() ?? 0,
      bookmarkStatus: map['bookmark_status'] ?? false,
      view: map['view']?.toInt() ?? 0,
      totalComment:
          map['total_comment'] != null ? int.parse(map['total_comment']) : 0,
      totalBookmark:
          map['total_bookmark'] != null ? int.parse(map['total_bookmark']) : 0,
      totalVoteUp:
          map['total_vote_up'] != null ? int.parse(map['total_vote_up']) : 0,
      totalVoteDown: map['total_vote_down'] != null
          ? int.parse(map['total_vote_down'])
          : 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Post(idPost: $idPost, idAccount: $idAccount, title: $title, dayCreated: $dayCreated, timeCreated: $timeCreated, status: $status, access: $access, bookmarkStatus: $bookmarkStatus, view: $view, totalComment: $totalComment, totalBookmark: $totalBookmark, totalVoteUp: $totalVoteUp, totalVoteDown: $totalVoteDown)';
  }
}
