import 'package:easy_localization/easy_localization.dart';

import '../../logic/constants/locale/locale_keys.g.dart';

class RetouchCommentValidator {
  String? comment;

  RetouchCommentValidator(this.comment);

  String? validate() {
    if (comment != null && comment!.isNotEmpty) {
      return null;
    } else {
      return LocaleKeys.retouchCommentEmptyWarning.tr();
    }
  }
}
