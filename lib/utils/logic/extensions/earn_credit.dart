import 'package:easy_localization/easy_localization.dart';

import '../constants/enums/app_enum.dart';
import '../constants/locale/locale_keys.g.dart';

extension MyEarnCredit on EarnCredit {
  int get credit {
    return switch (this) {
      EarnCredit.comment => 30,
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
