import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/num_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../utils/logic/constants/enums/app_enum.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/extensions/earn_credit.dart';
import '../../../components/credit_icon.dart';

class FreeCreditsItem extends StatelessWidget {
  final EarnCredit earnCredit;

  const FreeCreditsItem({
    super.key,
    required this.earnCredit,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      height: context.width / 3.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Ink(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: HexColor("#76BC51"),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${earnCredit.credit} ${LocaleKeys.credit.tr()}",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          10.horizontalSpace,
                          const CreditIcon(),
                        ],
                      ),
                      if (earnCredit == EarnCredit.comment)
                        Column(
                          children: [
                            3.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "ic_google_play".toPNG,
                                  width: 15,
                                  height: 15,
                                ),
                                8.horizontalSpace,
                                Image.asset(
                                  "ic_app_store".toPNG,
                                  width: 15,
                                  height: 15,
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Ink(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      earnCredit.description,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (earnCredit != EarnCredit.comment)
            Ink(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
                color: Colors.black.withOpacity(0.5),
              ),
            ),
        ],
      ),
    );
  }
}
