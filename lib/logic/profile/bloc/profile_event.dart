part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileUpdated extends ProfileEvent {
  final String realName;
  final String birth;
  final int gender;
  final String phone;
  final String company;

  const ProfileUpdated({
    required this.realName,
    required this.birth,
    required this.gender,
    required this.phone,
    required this.company,
  });

  @override
  List<Object> get props => [realName, birth, gender, phone, company];
}

class ProfileUpdatedFull extends ProfileEvent {
  final String realName;
  final String birth;
  final int gender;
  final String phone;
  final String company;
  final File? avatar;

  const ProfileUpdatedFull({
    required this.realName,
    required this.birth,
    required this.gender,
    required this.phone,
    required this.company,
    required this.avatar,
  });

  @override
  List<Object> get props => [realName, birth, gender, phone, company];
}

class ProfileUpdatedAvatar extends ProfileEvent {
  final File avatar;

  const ProfileUpdatedAvatar(this.avatar);

  @override
  List<Object> get props => [avatar];
}
