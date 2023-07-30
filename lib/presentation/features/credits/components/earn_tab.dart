import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/num_extension.dart';
import '../../../../utils/logic/constants/enums/app_enum.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import 'earn_dialog.dart';
import 'free_credits_item.dart';

class EarnTab extends StatelessWidget {
  const EarnTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            LocaleKeys.freeCreditsDescription.tr(),
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          20.verticalSpace,
          Wrap(
            spacing: 10,
            runSpacing: 10,
            direction: Axis.horizontal,
            children: EarnCredit.values.map((item) {
              return SizedBox(
                width: context.width / 2 - 15,
                child: InkWell(
                  onTap: item == EarnCredit.comment
                      ? () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const EarnDialog();
                            },
                          );
                        }
                      : null,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                  child: FreeCreditsItem(
                    earnCredit: item,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
