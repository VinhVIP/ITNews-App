import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:it_news/data/models/tag.dart';
import 'package:it_news/data/repositories/tag_repository.dart';
import 'package:it_news/logic/tags/models/tag_element.dart';

part 'tags_event.dart';
part 'tags_state.dart';

class TagsBloc extends Bloc<TagsEvent, TagsState> {
  final TagRepository tagRepository;

  TagsBloc(this.tagRepository) : super(const TagsState()) {
    on<TagsFetched>(_onTagsFetched);
    on<TagsFollowingFetched>(_onTagsFollowingFetched);
    on<TagFollowed>(_onTagFollowed);
    on<TagUnFollowed>(_onTagUnFollowed);
    on<TagSelected>(_onTagSelected);
    on<TagFetchedWithSelection>(_onTagSelectionInitial);
  }

  void _onTagsFetched(TagsFetched event, Emitter<TagsState> emit) async {
    emit(state.copyWith(fetchedStatus: TagsFetchedStatus.loading));

    final List<Tag>? tags = await tagRepository.getAllTags(event.idAccount);

    if (tags != null) {
      final List<TagElement> tagsElement =
          tags.map((tag) => TagElement(tag, TagFollowStatus.success)).toList();
      emit(state.copyWith(
          tags: tagsElement, fetchedStatus: TagsFetchedStatus.success));
    } else {
      emit(state.copyWith(fetchedStatus: TagsFetchedStatus.failure));
    }
  }

  void _onTagSelectionInitial(
      TagFetchedWithSelection event, Emitter<TagsState> emit) async {
    final List<Tag>? tags = await tagRepository.getTags();
    if (tags != null) {
      final List<TagElement> tagsElement =
          tags.map((tag) => TagElement(tag, TagFollowStatus.success)).toList();
      for (int i = 0; i < event.tagsSelection.length; i++) {
        int index = tagsElement.indexWhere(
            (element) => element.tag.idTag == event.tagsSelection[i].idTag);
        tagsElement[index] = tagsElement[index].copyWith(isSelected: true);
      }
      emit(state.copyWith(
          tags: tagsElement, fetchedStatus: TagsFetchedStatus.success));
    } else {
      emit(state.copyWith(message: "Không có thẻ để chọn"));
    }
  }

  void _onTagSelected(TagSelected event, Emitter<TagsState> emit) {
    final index =
        state.tags.indexWhere((element) => element.tag.idTag == event.idTag);

    bool selected = !state.tags[index].isSelected;

    if (selected) {
      int count = 0;
      for (int i = 0; i < state.tags.length; i++) {
        if (state.tags[i].isSelected) count++;
      }
      if (count >= 5) {
        emit(state.copyWith(message: "Chỉ được chọn tối đa 5 thẻ!"));
        return;
      }
    }

    final tag = state.tags[index].copyWith(
      isSelected: selected,
    );
    final List<TagElement> list = List.from(state.tags);
    list.removeAt(index);
    list.insert(index, tag);
    emit(state.copyWith(tags: list));
  }

  void _onTagsFollowingFetched(
      TagsFollowingFetched event, Emitter<TagsState> emit) async {
    emit(state.copyWith(fetchedStatus: TagsFetchedStatus.loading));

    final List<Tag>? tags =
        await tagRepository.getFolowingTags(event.idAccount);

    if (tags != null) {
      final List<TagElement> tagsElement =
          tags.map((tag) => TagElement(tag, TagFollowStatus.success)).toList();
      emit(state.copyWith(
          tags: tagsElement, fetchedStatus: TagsFetchedStatus.success));
    } else {
      emit(state.copyWith(fetchedStatus: TagsFetchedStatus.failure));
    }
  }

  void _onTagFollowed(TagFollowed event, Emitter<TagsState> emit) async {
    int position = state.findTagElement(event.idTag);

    List<TagElement> tags = List.from(state.tags);
    TagElement tagElement =
        tags[position].copyWith(followStatus: TagFollowStatus.loading);
    tags[position] = tagElement;

    emit(state.copyWith(tags: tags));

    final response = await tagRepository.followTag(event.idTag);
    if (response.statusCode == 200) {
      tags = List.from(state.tags);

      final Tag tag = tagElement.tag.copyWith(
        statusFollow: true,
        totalFollower: tagElement.tag.totalFollower + 1,
      );
      tagElement = tagElement.copyWith(
        tag: tag,
        followStatus: TagFollowStatus.success,
      );

      tags[position] = tagElement;

      emit(state.copyWith(tags: tags));
    } else {
      final body = json.decode(response.body);
      emit(state.copyWith(
        message: body['message'],
      ));
    }
  }

  void _onTagUnFollowed(TagUnFollowed event, Emitter<TagsState> emit) async {
    int position = state.findTagElement(event.idTag);

    List<TagElement> tags = List.from(state.tags);
    TagElement tagElement =
        tags[position].copyWith(followStatus: TagFollowStatus.loading);
    tags[position] = tagElement;

    emit(state.copyWith(tags: tags));

    final response = await tagRepository.unFollowTag(event.idTag);
    if (response.statusCode == 200) {
      tags = List.from(state.tags);

      final Tag tag = tagElement.tag.copyWith(
        statusFollow: false,
        totalFollower: tagElement.tag.totalFollower - 1,
      );
      tagElement = tagElement.copyWith(
        tag: tag,
        followStatus: TagFollowStatus.success,
      );

      tags[position] = tagElement;

      emit(state.copyWith(tags: tags));
    } else {
      final body = json.decode(response.body);
      emit(state.copyWith(
        message: body['message'],
      ));
    }
  }
}
