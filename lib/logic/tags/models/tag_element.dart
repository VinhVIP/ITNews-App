import 'package:equatable/equatable.dart';

import 'package:it_news/data/models/tag.dart';

enum TagFollowStatus { loading, success, failure }

class TagElement extends Equatable {
  final Tag tag;
  final TagFollowStatus followStatus;

  const TagElement(this.tag, this.followStatus);

  @override
  List<Object?> get props => [tag, followStatus];

  TagElement copyWith({
    Tag? tag,
    TagFollowStatus? followStatus,
  }) {
    return TagElement(
      tag ?? this.tag,
      followStatus ?? this.followStatus,
    );
  }
}
