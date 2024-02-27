import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/num_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/ui/constants/colors/app_colors.dart';

class ExtraCredit extends StatelessWidget {
  final int? extra;

  const ExtraCredit({
    super.key,
    required this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (extra != null && extra! > 0) ...[
            Text(
              "+$extra%",
              style: TextStyle(
                color: AppColors.mainColor,
                fontSize: 12,
              ),
            ),
            3.horizontalSpace,
            ImageIcon(
              AssetImage("ic_star".toPNG),
              color: AppColors.mainColor,
              size: 9,
            ),
            3.horizontalSpace,
            Text(
              LocaleKeys.extra.tr(),
              style: TextStyle(
                color: AppColors.mainColor,
                fontSize: 12,
              ),
            ),
          ] else ...[
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  LocaleKeys.noExtraCredits.tr(),
                  style: TextStyle(
                    color: AppColors.mainColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
