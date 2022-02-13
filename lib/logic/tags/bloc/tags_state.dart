part of 'tags_bloc.dart';

enum TagsFetchedStatus { initial, loading, success, failure }

class TagsState extends Equatable {
  final List<TagElement> tags;
  final TagsFetchedStatus fetchedStatus;
  final String message;

  const TagsState({
    this.tags = const <TagElement>[],
    this.fetchedStatus = TagsFetchedStatus.initial,
    this.message = "",
  });

  @override
  List<Object> get props => [tags, fetchedStatus, message];

  TagsState copyWith({
    List<TagElement>? tags,
    TagsFetchedStatus? fetchedStatus,
    String? message,
  }) {
    return TagsState(
      tags: tags ?? this.tags,
      fetchedStatus: fetchedStatus ?? this.fetchedStatus,
      message: message ?? "",
    );
  }

  int findTagElement(int idTag) {
    for (int i = 0; i < tags.length; i++) {
      if (tags[i].tag.idTag == idTag) return i;
    }
    return -1;
  }
}
