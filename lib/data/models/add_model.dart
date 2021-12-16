import 'package:formz/formz.dart';

enum TaskValidationError { empty }

class FormzNameModel extends FormzInput<String, TaskValidationError> {
  const FormzNameModel.pure() : super.pure('');

  const FormzNameModel.dirty([String value = '']) : super.dirty(value);

  @override
  TaskValidationError? validator(String value) {
    return value.isEmpty ? TaskValidationError.empty : null;
  }
}
