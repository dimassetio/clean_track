import 'package:nb_utils/nb_utils.dart';

String? requiredValidator(String? value) =>
    value.isEmptyOrNull ? "This field is required!" : null;

String? emailValidator(String? value) =>
    value.validateEmail() ? null : "Email is not valid!";

String? minLengthValidator(String? value, int length) =>
    (value?.length ?? 0) < length
        ? "Character must be at least ${length}!"
        : null;
