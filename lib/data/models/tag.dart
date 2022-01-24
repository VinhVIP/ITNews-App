import 'dart:convert';

import 'package:equatable/equatable.dart';

class Tag extends Equatable {
  final int idTag;
  final String name;
  final String logo;
  final int totalPost;
  final int totalFollower;
  final bool statusFollow;

  const Tag({
    required this.idTag,
    required this.name,
    required this.logo,
    this.totalPost = 0,
    this.totalFollower = 0,
    this.statusFollow = false,
  });

  @override
  List<Object> get props =>
      [idTag, name, logo, totalPost, totalFollower, statusFollow];

  Tag copyWith({
    int? idTag,
    String? name,
    String? logo,
    int? totalPost,
    int? totalFollower,
    bool? statusFollow,
  }) {
    return Tag(
      idTag: idTag ?? this.idTag,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      totalPost: totalPost ?? this.totalPost,
      totalFollower: totalFollower ?? this.totalFollower,
      statusFollow: statusFollow ?? this.statusFollow,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_tag': idTag,
      'name': name,
      'logo': logo,
      'total_post': totalPost,
      'total_follower': totalFollower,
      'status': statusFollow,
    };
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      idTag: map['id_tag']?.toInt() ?? 0,
      name: map['name'] ?? '',
      logo: map['logo'] ?? '',
      totalPost: map['total_post'] != null ? int.parse(map['total_post']) : 0,
      totalFollower:
          map['total_follower'] != null ? int.parse(map['total_follower']) : 0,
      statusFollow: map['status'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Tag.fromJson(String source) => Tag.fromMap(json.decode(source));

  @override
  String toString() => 'Tag(idTag: $idTag, name: $name, logo: $logo)';
}
