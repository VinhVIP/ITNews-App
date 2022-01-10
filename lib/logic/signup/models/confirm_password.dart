import 'package:formz/formz.dart';

enum ConfirmPasswordValidationError { empty }

class ConfirmPassword
    extends FormzInput<List<String>?, ConfirmPasswordValidationError> {
  const ConfirmPassword.pure() : super.pure(null);
  const ConfirmPassword.dirty(List<String>? value) : super.dirty(value);

  @override
  ConfirmPasswordValidationError? validator(List<String>? value) {
    if (value == null) return ConfirmPasswordValidationError.empty;
    if (value[0] != value[1]) return ConfirmPasswordValidationError.empty;
    return null;
  }
}
