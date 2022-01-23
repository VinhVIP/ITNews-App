import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable {
  static const empty = User();

  static const int ROLE_ADMIN = 1;
  static const int ROLE_MODERATOR = 2;
  static const int ROLE_USER = 3;

  final int idAccount;
  final int idRole;
  final String role;
  final String accountName;
  final String realName;
  final String email;
  final int gender;
  final String avatar;
  final String company;
  final String phone;
  final String birth;
  final String createDate;
  final int totalPost;
  final int totalTagFollow;
  final int totalFollower;
  final int totalFollowing;
  final int totalView;
  final int totalVoteUp;
  final int totalVoteDown;

  const User({
    this.idAccount = 0,
    this.idRole = 2,
    this.role = "User",
    this.accountName = "",
    this.realName = "",
    this.email = "",
    this.gender = 0,
    this.avatar = "",
    this.company = "",
    this.phone = "",
    this.birth = "",
    this.createDate = "",
    this.totalPost = 0,
    this.totalTagFollow = 0,
    this.totalFollower = 0,
    this.totalFollowing = 0,
    this.totalView = 0,
    this.totalVoteUp = 0,
    this.totalVoteDown = 0,
  });

  @override
  List<Object?> get props => [
        idAccount,
        idRole,
        role,
        accountName,
        realName,
        email,
        gender,
        avatar,
        company,
        phone,
        birth,
        createDate,
        totalPost,
        totalTagFollow,
        totalFollower,
        totalFollowing,
        totalView,
        totalVoteUp,
        totalVoteDown
      ];

  Map<String, dynamic> toMap() {
    return {
      'id_account': idAccount,
      'id_role': idRole,
      'role': role,
      'account_name': accountName,
      'real_name': realName,
      'email': email,
      'gender': gender,
      'avatar': avatar,
      'company': company,
      'phone': phone,
      'birth': birth,
      'create_date': createDate,
      'total_post': totalPost,
      'total_tag_follow': totalTagFollow,
      'total_follower': totalFollower,
      'total_following': totalFollowing,
      'total_view': totalView,
      'total_vote_up': totalVoteUp,
      'total_vote_down': totalVoteDown,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      idAccount: map['id_account']?.toInt() ?? 0,
      idRole: map['id_role']?.toInt() ?? 0,
      role: map['role'] ?? '',
      accountName: map['account_name'] ?? '',
      realName: map['real_name'] ?? '',
      email: map['email'] ?? '',
      gender: map['gender']?.toInt() ?? 0,
      avatar: map['avatar'] ?? '',
      company: map['company'] ?? '',
      phone: map['phone'] ?? '',
      birth: map['birth'] ?? '',
      createDate: map['create_date'] ?? '',
      totalPost: map['total_post'] != null ? int.parse(map['total_post']) : 0,
      totalTagFollow: map['total_tag_follow'] != null
          ? int.parse(map['total_tag_follow'])
          : 0,
      totalFollower:
          map['total_follower'] != null ? int.parse(map['total_follower']) : 0,
      totalFollowing: map['total_following'] != null
          ? int.parse(map['total_following'])
          : 0,
      totalView: map['total_view'] != null ? int.parse(map['total_view']) : 0,
      totalVoteUp:
          map['total_vote_up'] != null ? int.parse(map['total_vote_up']) : 0,
      totalVoteDown: map['total_vote_down'] != null
          ? int.parse(map['total_vote_down'])
          : 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return "$idAccount - $accountName - $realName";
  }

  User copyWith({
    int? idAccount,
    int? idRole,
    String? role,
    String? accountName,
    String? realName,
    String? email,
    int? gender,
    String? avatar,
    String? company,
    String? phone,
    String? birth,
    String? createDate,
    int? totalPost,
    int? totalTagFollow,
    int? totalFollower,
    int? totalFollowing,
    int? totalView,
    int? totalVoteUp,
    int? totalVoteDown,
  }) {
    return User(
      idAccount: idAccount ?? this.idAccount,
      idRole: idRole ?? this.idRole,
      role: role ?? this.role,
      accountName: accountName ?? this.accountName,
      realName: realName ?? this.realName,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      avatar: avatar ?? this.avatar,
      company: company ?? this.company,
      phone: phone ?? this.phone,
      birth: birth ?? this.birth,
      createDate: createDate ?? this.createDate,
      totalPost: totalPost ?? this.totalPost,
      totalTagFollow: totalTagFollow ?? this.totalTagFollow,
      totalFollower: totalFollower ?? this.totalFollower,
      totalFollowing: totalFollowing ?? this.totalFollowing,
      totalView: totalView ?? this.totalView,
      totalVoteUp: totalVoteUp ?? this.totalVoteUp,
      totalVoteDown: totalVoteDown ?? this.totalVoteDown,
    );
  }
}
