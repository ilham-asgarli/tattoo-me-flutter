import 'package:easy_localization/easy_localization.dart';

import '../../../backend/utils/constants/app/app_constants.dart';
import '../constants/enums/app_enums.dart';
import '../constants/locale/locale_keys.g.dart';

extension MyEarnCredit on EarnCredit {
  int get credit {
    return switch (this) {
      EarnCredit.comment => AppConstants.tattooDesignPrice,
      EarnCredit.subscribe => 5,
      EarnCredit.follow => 10,
    };
  }

  String get description {
    return switch (this) {
      EarnCredit.comment => LocaleKeys.earnCredit_comment.tr(),
      EarnCredit.subscribe => LocaleKeys.earnCredit_subscribe.tr(),
      EarnCredit.follow => LocaleKeys.earnCredit_follow.tr(),
    };
  }
}
