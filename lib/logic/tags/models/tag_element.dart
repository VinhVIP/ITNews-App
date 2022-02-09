import 'package:equatable/equatable.dart';

import 'package:it_news/data/models/tag.dart';

enum TagFollowStatus { loading, success, failure }

class TagElement extends Equatable {
  final Tag tag;
  final TagFollowStatus followStatus;
  final bool isSelected;

  const TagElement(this.tag, this.followStatus, {this.isSelected = false});

  @override
  List<Object?> get props => [tag, followStatus, isSelected];

  TagElement copyWith({
    Tag? tag,
    TagFollowStatus? followStatus,
    bool? isSelected,
  }) {
    return TagElement(
      tag ?? this.tag,
      followStatus ?? this.followStatus,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
