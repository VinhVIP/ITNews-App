part of 'profile_bloc.dart';

enum ProfileUpdateStatus { loading, success, failure }

class ProfileState extends Equatable {
  final String message;
  final ProfileUpdateStatus updateStatus;

  const ProfileState({
    this.message = "",
    this.updateStatus = ProfileUpdateStatus.success,
  });

  @override
  List<Object> get props => [message, updateStatus];

  ProfileState copyWith({
    String? message,
    ProfileUpdateStatus? updateStatus,
  }) {
    return ProfileState(
      message: message ?? "",
      updateStatus: updateStatus ?? this.updateStatus,
    );
  }
}
