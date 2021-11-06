import 'package:formz/formz.dart';

enum TaskValidationError { empty }

class AddModel extends FormzInput<String, TaskValidationError> {
  const AddModel.pure() : super.pure('');

  const AddModel.dirty([String value = '']) : super.dirty(value);

  @override
  TaskValidationError? validator(String value) {
    return value.isEmpty ? TaskValidationError.empty : null;
  }
}
