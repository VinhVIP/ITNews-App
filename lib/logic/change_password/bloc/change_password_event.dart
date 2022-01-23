part of 'change_password_bloc.dart';

class ChangePasswordEvent extends Equatable {
  final String oldPass;
  final String newPass;

  const ChangePasswordEvent({required this.oldPass, required this.newPass});

  @override
  List<Object> get props => [oldPass, newPass];
}
