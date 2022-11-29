import 'package:easy_localization/easy_localization.dart';

import '../../logic/constants/locale/locale_keys.g.dart';

class EmailValidator {
  String? email;

  EmailValidator(this.email);

  String? validate() {
    if (email != null && email!.isNotEmpty) {
      return null;
    } else {
      return LocaleKeys.emptyEmailWarning.tr();
    }
  }
}
