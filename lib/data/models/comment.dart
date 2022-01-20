import 'dart:convert';

import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  static const int SHOW = 0;
  static const int HIDE = 1;

  final int idComment;
  final String content;
  final int idCommentParent;
  final int status;
  final int idAccount;
  final String accountName;
  final String realName;
  final int idRole;
  final String avatar;
  final String day;
  final String time;
  List<Comment> replies = [];

  bool isShow() {
    return status == SHOW;
  }

  Comment({
    this.idComment = 0,
    this.content = "",
    this.idCommentParent = 0,
    this.status = 0,
    this.idAccount = 0,
    this.accountName = "",
    this.realName = "",
    this.idRole = 0,
    this.avatar = "",
    this.day = "",
    this.time = "",
  });

  @override
  List<Object> get props {
    return [
      idComment,
      content,
      idCommentParent,
      status,
      idAccount,
      accountName,
      realName,
      idRole,
      avatar,
      day,
      time,
      replies,
    ];
  }

  Comment copyWith({
    int? idComment,
    String? content,
    int? idCommentParent,
    int? status,
    int? idAccount,
    String? accountName,
    String? realName,
    int? idRole,
    String? avatar,
    String? day,
    String? time,
    List<Comment>? replies,
  }) {
    return Comment(
      idComment: idComment ?? this.idComment,
      content: content ?? this.content,
      idCommentParent: idCommentParent ?? this.idCommentParent,
      status: status ?? this.status,
      idAccount: idAccount ?? this.idAccount,
      accountName: accountName ?? this.accountName,
      realName: realName ?? this.realName,
      idRole: idRole ?? this.idRole,
      avatar: avatar ?? this.avatar,
      day: day ?? this.day,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_cmt': idComment,
      'content': content,
      'id_cmt_parent': idCommentParent,
      'status': status,
      'id_account': idAccount,
      'account_name': accountName,
      'real_name': realName,
      'id_role': idRole,
      'avatar': avatar,
      'day': day,
      'time': time,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      idComment: map['id_cmt']?.toInt() ?? 0,
      content: map['content'] ?? '',
      idCommentParent: map['id_cmt_parent']?.toInt() ?? 0,
      status: map['status']?.toInt() ?? 0,
      idAccount: map['id_account']?.toInt() ?? 0,
      accountName: map['account_name'] ?? '',
      realName: map['real_name'] ?? '',
      idRole: map['id_role']?.toInt() ?? 0,
      avatar: map['avatar'] ?? '',
      day: map['day'] ?? '',
      time: map['time'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Comment(idComment: $idComment, content: $content, idCommentParent: $idCommentParent, status: $status, idAccount: $idAccount, accountName: $accountName, realName: $realName, idRole: $idRole, avatar: $avatar, day: $day, time: $time)';
  }
}
