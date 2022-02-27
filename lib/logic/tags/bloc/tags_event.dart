part of 'tags_bloc.dart';

class TagsEvent extends Equatable {
  const TagsEvent();

  @override
  List<Object> get props => [];
}

class TagsFetched extends TagsEvent {
  final int idAccount;

  const TagsFetched(this.idAccount);

  @override
  List<Object> get props => [idAccount];
}

class TagsFollowingFetched extends TagsEvent {
  final int idAccount;

  const TagsFollowingFetched(this.idAccount);

  @override
  List<Object> get props => [idAccount];
}

class TagFollowed extends TagsEvent {
  final int idTag;

  const TagFollowed(this.idTag);

  @override
  List<Object> get props => [idTag];
}

class TagUnFollowed extends TagsEvent {
  final int idTag;

  const TagUnFollowed(this.idTag);

  @override
  List<Object> get props => [idTag];
}

class TagsSearch extends TagsEvent {
  final String keyword;
  final bool isNew;

  const TagsSearch({required this.keyword, this.isNew = false});

  @override
  List<Object> get props => [keyword, isNew];
}

class TagSelected extends TagsEvent {
  final int idTag;

  const TagSelected(this.idTag);

  @override
  List<Object> get props => [idTag];
}

class TagFetchedWithSelection extends TagsEvent {
  final List<Tag> tagsSelection;

  const TagFetchedWithSelection(this.tagsSelection);

  @override
  List<Object> get props => [tagsSelection];
}

class TagUpdated extends TagsEvent {
  final int idTag;
  final String name;
  final File? logo;

  const TagUpdated({required this.idTag, required this.name, this.logo});

  @override
  List<Object> get props => [idTag, name];
}

class TagAdded extends TagsEvent {
  final String name;
  final File logo;

  const TagAdded({required this.name, required this.logo});

  @override
  List<Object> get props => [name, logo];
}

class TagDeleted extends TagsEvent {
  final int idTag;

  const TagDeleted(this.idTag);

  @override
  List<Object> get props => [idTag];
}
