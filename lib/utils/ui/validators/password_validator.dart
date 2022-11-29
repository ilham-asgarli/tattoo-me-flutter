import 'package:easy_localization/easy_localization.dart';

import '../../logic/constants/locale/locale_keys.g.dart';

class PasswordValidator {
  String? password;

  PasswordValidator(this.password);

  String? validate() {
    if (password != null && password!.isNotEmpty) {
      return null;
    } else {
      return LocaleKeys.emptyPasswordWarning.tr();
    }
  }
}
