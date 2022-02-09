import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:it_news/data/models/user.dart';
import 'package:it_news/data/repositories/account_repository.dart';
import 'package:it_news/logic/authors/models/author_element.dart';

part 'author_event.dart';
part 'author_state.dart';

class AuthorBloc extends Bloc<AuthorEvent, AuthorState> {
  final AccountRepository accountRepository;

  AuthorBloc({required this.accountRepository}) : super(const AuthorState()) {
    on<AuthorFetched>(_onAuthorFetched);
    on<AuthorUnFollowed>(_onAuthorUnFollowed);
    on<AuthorFollowed>(_onAuthorFollowed);
    on<AuthorRoleChanged>(_onAuthorRoleChanged);
    on<AuthorLockedTime>(_onAuthorLockedTime);
    on<AuthorLockedForever>(_onAuthorLockedForever);
    on<AuthorUnlocked>(_onAuthorUnlocked);
    on<AuthorViewUser>(_onAuthorViewUser);
  }

  void _onAuthorViewUser(AuthorViewUser event, Emitter<AuthorState> emit) {
    emit(state.copyWith(
        authorElement: state.authorElement.copyWith(author: event.user)));
  }

  void _onAuthorFetched(AuthorFetched event, Emitter<AuthorState> emit) async {
    emit(state.copyWith(fetchedStatus: AuthorFetchedStatus.loading));

    final author = await accountRepository.getUser(idAccount: event.idAccount);
    print(author);
    emit(state.copyWith(
      authorElement: AuthorElement(author!, AuthorFollowStatus.success),
      fetchedStatus: AuthorFetchedStatus.success,
    ));
  }

  void _onAuthorFollowed(
      AuthorFollowed event, Emitter<AuthorState> emit) async {
    emit(state.copyWith(
        authorElement: state.authorElement
            .copyWith(followStatus: AuthorFollowStatus.loading)));

    final response = await accountRepository.followAccount(event.idAccount);
    if (response.statusCode == 200) {
      final User author =
          state.authorElement.author.copyWith(followStatus: true);
      final AuthorElement authorElement = state.authorElement.copyWith(
        author: author,
        followStatus: AuthorFollowStatus.success,
      );

      emit(state.copyWith(authorElement: authorElement));
    } else {
      debugPrint(response.body);
    }
  }

  void _onAuthorUnFollowed(
      AuthorUnFollowed event, Emitter<AuthorState> emit) async {
    emit(state.copyWith(
        authorElement: state.authorElement
            .copyWith(followStatus: AuthorFollowStatus.loading)));

    final response = await accountRepository.unFollowAccount(event.idAccount);
    if (response.statusCode == 200) {
      final User author =
          state.authorElement.author.copyWith(followStatus: false);
      final AuthorElement authorElement = state.authorElement.copyWith(
        author: author,
        followStatus: AuthorFollowStatus.success,
      );

      emit(state.copyWith(authorElement: authorElement));
    }
  }

  void _onAuthorRoleChanged(
      AuthorRoleChanged event, Emitter<AuthorState> emit) async {
    final response =
        await accountRepository.changeRole(event.idAccount, event.role);
    if (response.statusCode == 200) {
      final User author = state.authorElement.author.copyWith(
          idRole: event.role,
          role: event.role == 1
              ? "Admin"
              : event.role == 2
                  ? "Moder"
                  : "User");
      emit(state.copyWith(
          authorElement: state.authorElement.copyWith(author: author)));
    } else {
      debugPrint("loi thay doi chuc vu");
      final body = json.decode(response.body);
      emit(state.copyWith(message: body['message']));
    }
  }

  void _onAuthorLockedTime(
      AuthorLockedTime event, Emitter<AuthorState> emit) async {
    final response = await accountRepository.lockTime(
      event.idAccount,
      event.reason,
      event.hoursLock,
    );
    if (response.statusCode == 200) {
      final User author = state.authorElement.author.copyWith(accountStatus: 1);
      emit(
        state.copyWith(
          authorElement: state.authorElement.copyWith(author: author),
          message: "Đã khóa tạm thời tài khoản này!",
        ),
      );
    } else {
      debugPrint("loi khoa tam thoi");
      final body = json.decode(response.body);
      emit(state.copyWith(message: body['message']));
    }
  }

  void _onAuthorLockedForever(
      AuthorLockedForever event, Emitter<AuthorState> emit) async {
    final response = await accountRepository.lockForever(
      event.idAccount,
      event.reason,
    );
    if (response.statusCode == 200) {
      final User author = state.authorElement.author.copyWith(accountStatus: 2);
      emit(
        state.copyWith(
          authorElement: state.authorElement.copyWith(author: author),
          message: "Đã khóa vĩnh viễn tài khoản này!",
        ),
      );
    } else {
      final body = json.decode(response.body);
      emit(state.copyWith(message: body['message']));
    }
  }

  void _onAuthorUnlocked(
      AuthorUnlocked event, Emitter<AuthorState> emit) async {
    final response = await accountRepository.unlock(event.idAccount);
    if (response.statusCode == 200) {
      final User author = state.authorElement.author.copyWith(accountStatus: 0);
      emit(
        state.copyWith(
          authorElement: state.authorElement.copyWith(author: author),
          message: "Đã mở khóa tài khoản!",
        ),
      );
    } else {
      debugPrint("loi mo khoa tai khoan");
      final body = json.decode(response.body);
      emit(state.copyWith(message: body['message']));
    }
  }
}
