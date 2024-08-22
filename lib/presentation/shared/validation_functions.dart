import 'package:easy_localization/easy_localization.dart';
import 'package:shopesapp/presentation/shared/utils.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';

confirmPassword(value, password) {
  if (value!.isNotEmpty) {
    if (!validPassword(value)) return LocaleKeys.invalid_password.tr();
    return password != value ? LocaleKeys.not_match.tr() : null;
  } else {
    return LocaleKeys.enter_your_password.tr();
  }
}

String? passValidator(value) {
  if (value!.isNotEmpty) {
    if (!validPassword(value)) {
      return LocaleKeys.invalid_password.tr();
    }
    return null;
  } else {
    return LocaleKeys.enter_your_password.tr();
  }
}

String? numberValidator(value, String? warningMessage) {
  if (value!.isNotEmpty) {
    if (!isMobileNumber(value)) {
      return LocaleKeys.invalid_number.tr();
    }
    return null;
  } else {
    return warningMessage ?? LocaleKeys.enter_your_number.tr();
  }
}

emailValidator(String? value, String? warningMessage) {
  if (value!.isNotEmpty) {
    if (!isEmail(value)) {
      return LocaleKeys.invalid_email.tr();
    }
    return null;
  } else {
    return warningMessage ?? LocaleKeys.enter_your_email.tr();
  }
}

nameValidator(String? value, String? warningMessage) {
  if (value!.isNotEmpty) {
    if (!isName(value)) {
      return LocaleKeys.invalid_name.tr();
    }
    return null;
  } else {
    return warningMessage ?? LocaleKeys.enter_your_name.tr();
  }
}

editNameValidator(String? value) {
  if (value!.isNotEmpty) {
    if (!isName(value)) {
      return LocaleKeys.invalid_name.tr();
    }
  }
  return null;
}

String? editNumberValidator(value) {
  if (value!.isNotEmpty) {
    if (!isMobileNumber(value)) {
      return LocaleKeys.invalid_number.tr();
    }
  }
  return null;
}
