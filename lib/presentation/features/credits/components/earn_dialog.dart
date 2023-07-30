import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/num_extension.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../components/credit_icon.dart';

class EarnDialog extends StatelessWidget {
  const EarnDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.normalValue * 1.3,
          horizontal: context.normalValue,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.earnCreditDescription_comment.tr(args: ["30"]),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            (context.normalValue * 1.3).verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const CreditIcon(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor("#636363"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    LocaleKeys.goStore.tr(),
                  ),
                ),
                const CreditIcon(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
