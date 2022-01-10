import 'package:formz/formz.dart';

enum AccountNameValidationError { empty }

class AccountName extends FormzInput<String, AccountNameValidationError> {
  const AccountName.pure() : super.pure('');
  const AccountName.dirty([String value = '']) : super.dirty(value);

  @override
  AccountNameValidationError? validator(String? value) {
    return value?.isNotEmpty == true ? null : AccountNameValidationError.empty;
  }
}
