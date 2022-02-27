import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:it_news/core/utils/utils.dart';
import 'package:it_news/data/repositories/account_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AccountRepository _accountRepository;

  ProfileBloc({required AccountRepository accountRepository})
      : _accountRepository = accountRepository,
        super(const ProfileState()) {
    on<ProfileUpdated>(_onProfileUpdated);
    on<ProfileUpdatedFull>(_onProfileUpdatedFull);
    on<ProfileUpdatedAvatar>(_onProfileUpdateAvatar);
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

  void _onProfileUpdatedFull(
    ProfileUpdatedFull event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(updateStatus: ProfileUpdateStatus.loading));
    final response = await _accountRepository.updateProfileFull(
      realName: event.realName,
      birth: event.birth,
      gender: event.gender,
      phone: event.phone,
      company: event.company,
      imageFile: event.avatar,
    );

    final strBody = await response.stream.bytesToString();
    final body = json.decode(strBody);

    if (response.statusCode == 200) {
      emit(state.copyWith(
        message: body['message'],
        updateStatus: ProfileUpdateStatus.success,
      ));
    } else {
      emit(state.copyWith(
        message: body['message'],
        updateStatus: ProfileUpdateStatus.failure,
      ));
    }
  }

  void _onProfileUpdateAvatar(
      ProfileUpdatedAvatar event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(updateStatus: ProfileUpdateStatus.loading));
    final response = await _accountRepository.updateAvatar(event.avatar);

    final strBody = await response.stream.bytesToString();
    final body = json.decode(strBody);

    if (response.statusCode == 200) {
      print(body['data']);
      final avatar = body['data'];
      print(Utils.user);
      Utils.user = Utils.user.copyWith(avatar: avatar);

      emit(state.copyWith(
        message: body['message'],
        updateStatus: ProfileUpdateStatus.success,
      ));
    } else {
      emit(state.copyWith(
        message: body['message'],
        updateStatus: ProfileUpdateStatus.failure,
      ));
    }
  }
}
