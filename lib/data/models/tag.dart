import 'dart:convert';

import 'package:equatable/equatable.dart';

class Tag extends Equatable {
  final int idTag;
  final String name;
  final String logo;

  const Tag({
    required this.idTag,
    required this.name,
    required this.logo,
  });

  @override
  List<Object> get props => [idTag, name, logo];

  Tag copyWith({
    int? idTag,
    String? name,
    String? logo,
  }) {
    return Tag(
      idTag: idTag ?? this.idTag,
      name: name ?? this.name,
      logo: logo ?? this.logo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_tag': idTag,
      'name': name,
      'logo': logo,
    };
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      idTag: map['id_tag']?.toInt() ?? 0,
      name: map['name'] ?? '',
      logo: map['logo'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Tag.fromJson(String source) => Tag.fromMap(json.decode(source));

  @override
  String toString() => 'Tag(idTag: $idTag, name: $name, logo: $logo)';
}
