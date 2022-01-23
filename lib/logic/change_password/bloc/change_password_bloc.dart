import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:it_news/data/repositories/account_repository.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final AccountRepository accountRepository;
  ChangePasswordBloc({
    required this.accountRepository,
  }) : super(const ChangePasswordState()) {
    on<ChangePasswordEvent>(_onChangePassword);
  }

  Future<void> _onChangePassword(
      ChangePasswordEvent event, Emitter<ChangePasswordState> emit) async {
    emit(state.copyWith(status: ChangePasswordStatus.loading));
    final response =
        await accountRepository.changePassword(event.oldPass, event.newPass);
    final body = json.decode(response.body);
    if (response.statusCode == 200) {
      emit(state.copyWith(
          message: body['message'], status: ChangePasswordStatus.success));
    } else {
      emit(state.copyWith(
          message: body['message'], status: ChangePasswordStatus.failure));
    }
  }
}
