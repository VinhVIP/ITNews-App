import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:it_news/data/repositories/account_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AccountRepository _accountRepository;

  ProfileBloc({required AccountRepository accountRepository})
      : _accountRepository = accountRepository,
        super(const ProfileState()) {
    on<ProfileUpdated>(_onProfileUpdated);
  }

  void _onProfileUpdated(
    ProfileUpdated event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(updateStatus: ProfileUpdateStatus.loading));
    final response = await _accountRepository.updateProfile(
      realName: event.realName,
      birth: event.birth,
      gender: event.gender,
      phone: event.phone,
      company: event.company,
    );

    final body = json.decode(response.body);
    emit(state.copyWith(
      message: body['message'],
      updateStatus: ProfileUpdateStatus.success,
    ));
  }
}
