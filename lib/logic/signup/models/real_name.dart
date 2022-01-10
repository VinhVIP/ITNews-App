import 'package:formz/formz.dart';

enum RealNameValidationError { empty }

class RealName extends FormzInput<String, RealNameValidationError> {
  const RealName.pure() : super.pure('');
  const RealName.dirty([String value = '']) : super.dirty(value);

  @override
  RealNameValidationError? validator(String? value) {
    return value?.isNotEmpty == true ? null : RealNameValidationError.empty;
  }
}
