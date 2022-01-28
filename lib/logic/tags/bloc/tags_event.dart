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
