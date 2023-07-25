import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/num_extension.dart';
import '../../../../core/extensions/widget_extension.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/ui/constants/colors/app_colors.dart';
import 'buy.dart';
import 'ios_store_area.dart';
import 'subscribe.dart';

class BuyTab extends StatelessWidget {
  const BuyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.tertiary,
              borderRadius: BorderRadius.circular(7),
            ),
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              LocaleKeys.creditsDescription.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          10.verticalSpace,
          const Subscribe(),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 15,
              bottom: 10,
            ),
            child: Text(
              LocaleKeys.oneTimePurchase.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const Center(
            child: Buy(),
          ),
          context.widget.verticalSpace(20),
          const IosStoreArea(),
        ],
      ),
    );
  }
}
