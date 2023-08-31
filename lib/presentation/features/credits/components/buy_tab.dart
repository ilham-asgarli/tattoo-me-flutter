import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../backend/utils/constants/app/app_constants.dart';
import '../../../../core/extensions/num_extension.dart';
import '../../../../core/extensions/widget_extension.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import 'buy.dart';
import 'ios_store_area.dart';
import 'subscribe.dart';

class BuyTab extends StatelessWidget {
  const BuyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: HexColor("161616"),
                borderRadius: BorderRadius.circular(7),
              ),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                LocaleKeys.creditsDescription.tr(args: [
                  AppConstants.tattooDesignPrice.toString(),
                ]),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12.5,
                ),
              ),
            ),
          ),
          37.verticalSpace,
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
