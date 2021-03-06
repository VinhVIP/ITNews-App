import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:it_news/data/models/user.dart';
import 'package:it_news/data/repositories/account_repository.dart';
import 'package:it_news/logic/authors/models/author_element.dart';

part 'authors_event.dart';
part 'authors_state.dart';

class AuthorsBloc extends Bloc<AuthorsEvent, AuthorsState> {
  final AccountRepository accountRepository;
  AuthorsBloc(this.accountRepository) : super(const AuthorsState()) {
    on<AuthorsFetched>(_onAuthorsFetched);
    on<AuthorFollowersFetched>(_onAuthorFollowersFetched);
    on<AuthorFollowingsFetched>(_onAuthorFollowingsFetched);
    on<AuthorFollowed>(_onAuthorFollowed);
    on<AuthorUnFollowed>(_onAuthorUnFollowed);
    on<AuthorsSearch>(_onAuthorsSearch);
  }

  void _onAuthorsFetched(
      AuthorsFetched event, Emitter<AuthorsState> emit) async {
    emit(state.copyWith(fetchedStatus: AuthorsFetchedStatus.loading));

    final List<User>? authors = await accountRepository.getAllAuthors();

    if (authors != null) {
      final List<AuthorElement> authorsElement = authors
          .map((author) => AuthorElement(author, AuthorFollowStatus.success))
          .toList();
      emit(state.copyWith(
          authors: authorsElement,
          fetchedStatus: AuthorsFetchedStatus.success));
    } else {
      emit(state.copyWith(fetchedStatus: AuthorsFetchedStatus.failure));
    }
  }

  void _onAuthorsSearch(AuthorsSearch event, Emitter<AuthorsState> emit) async {
    try {
      if (event.isNew) {
        emit(state.copyWith(fetchedStatus: AuthorsFetchedStatus.loading));

        final authors = await accountRepository.search(
          keyword: event.keyword,
          page: 1,
        );

        if (authors != null) {
          final List<AuthorElement> authorsElement = authors
              .map((author) => AuthorElement(
                    author,
                    AuthorFollowStatus.success,
                  ))
              .toList();
          emit(state.copyWith(
            fetchedStatus: AuthorsFetchedStatus.success,
            authors: authorsElement,
            keyword: event.keyword,
            hasReachedMax: authors.length < 10 ? true : false,
          ));
        } else {
          emit(state.copyWith(fetchedStatus: AuthorsFetchedStatus.failure));
        }
      } else {
        if (state.hasReachedMax) return;

        int size = state.authors.length;
        final nextPage = (size / 10).ceil() + 1;
        final authors = await accountRepository.search(
          keyword: event.keyword,
          page: nextPage,
        );

        if (authors == null || authors.isEmpty) {
          emit(state.copyWith(hasReachedMax: true));
        } else {
          final List<AuthorElement> authorsElement = authors
              .map((author) => AuthorElement(
                    author,
                    AuthorFollowStatus.success,
                  ))
              .toList();
          emit(state.copyWith(
            fetchedStatus: AuthorsFetchedStatus.success,
            authors: List.from(state.authors)..addAll(authorsElement),
            hasReachedMax: authors.length < 10,
          ));
        }
      }
    } catch (e) {
      emit(state.copyWith(fetchedStatus: AuthorsFetchedStatus.failure));
    }
  }

  void _onAuthorFollowersFetched(
      AuthorFollowersFetched event, Emitter<AuthorsState> emit) async {
    emit(state.copyWith(fetchedStatus: AuthorsFetchedStatus.loading));

    final List<User>? authors =
        await accountRepository.getFollowers(event.idAccount);

    if (authors != null) {
      final List<AuthorElement> authorsElement = authors
          .map((author) => AuthorElement(author, AuthorFollowStatus.success))
          .toList();
      emit(state.copyWith(
          authors: authorsElement,
          fetchedStatus: AuthorsFetchedStatus.success));
    } else {
      emit(state.copyWith(fetchedStatus: AuthorsFetchedStatus.failure));
    }
  }

  void _onAuthorFollowingsFetched(
      AuthorFollowingsFetched event, Emitter<AuthorsState> emit) async {
    emit(state.copyWith(fetchedStatus: AuthorsFetchedStatus.loading));

    final List<User>? authors =
        await accountRepository.getFollowings(event.idAccount);

    if (authors != null) {
      final List<AuthorElement> authorsElement = authors
          .map((author) => AuthorElement(author, AuthorFollowStatus.success))
          .toList();
      emit(state.copyWith(
          authors: authorsElement,
          fetchedStatus: AuthorsFetchedStatus.success));
    } else {
      emit(state.copyWith(fetchedStatus: AuthorsFetchedStatus.failure));
    }
  }

  void _onAuthorFollowed(
      AuthorFollowed event, Emitter<AuthorsState> emit) async {
    int position = state.findAuthorElement(event.idAccount);

    List<AuthorElement> authors = List.from(state.authors);
    AuthorElement authorElement =
        authors[position].copyWith(followStatus: AuthorFollowStatus.loading);
    authors[position] = authorElement;

    emit(state.copyWith(authors: authors));

    final response = await accountRepository.followAccount(event.idAccount);
    if (response.statusCode == 200) {
      authors = List.from(state.authors);

      final User tag = authorElement.author.copyWith(
        followStatus: true,
        totalFollower: authorElement.author.totalFollower + 1,
      );
      authorElement = authorElement.copyWith(
        author: tag,
        followStatus: AuthorFollowStatus.success,
      );

      authors[position] = authorElement;

      emit(state.copyWith(authors: authors));
    } else {
      final body = json.decode(response.body);
      emit(state.copyWith(
        message: body['message'],
      ));
    }
  }

  void _onAuthorUnFollowed(
      AuthorUnFollowed event, Emitter<AuthorsState> emit) async {
    int position = state.findAuthorElement(event.idAccount);

    List<AuthorElement> authors = List.from(state.authors);
    AuthorElement authorElement =
        authors[position].copyWith(followStatus: AuthorFollowStatus.loading);
    authors[position] = authorElement;

    emit(state.copyWith(authors: authors));

    final response = await accountRepository.unFollowAccount(event.idAccount);
    if (response.statusCode == 200) {
      authors = List.from(state.authors);

      final User tag = authorElement.author.copyWith(
        followStatus: false,
        totalFollower: authorElement.author.totalFollower - 1,
      );
      authorElement = authorElement.copyWith(
        author: tag,
        followStatus: AuthorFollowStatus.success,
      );

      authors[position] = authorElement;

      emit(state.copyWith(authors: authors));
    } else {
      final body = json.decode(response.body);
      emit(state.copyWith(
        message: body['message'],
      ));
    }
  }
}
