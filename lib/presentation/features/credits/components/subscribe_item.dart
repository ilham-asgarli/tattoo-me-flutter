import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../core/extensions/num_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../utils/logic/constants/enums/purchase_enums.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/helpers/purchase/purchase_helper.dart';
import '../../../../utils/logic/state/cubit/purchase/purchase_cubit.dart';
import '../../../../utils/ui/constants/colors/app_colors.dart';
import 'extra_credit.dart';

class SubscribeItem extends StatelessWidget {
  final ProductDetails productDetails;

  const SubscribeItem({
    Key? key,
    required this.productDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: Stack(
        children: [
          /*Advantageous(
            purchase: Purchase.subscription,
            isAdvantageous: productDetails.id ==
                PurchaseHelper.instance.getAllIds(Purchase.subscription)[1],
          ),*/
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          PurchaseHelper.instance
                              .getCreditsForId(
                                  Purchase.subscription, productDetails.id)
                              .toString(),
                          style: TextStyle(
                            color: AppColors.secondColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        2.horizontalSpace,
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: ImageIcon(
                            AssetImage("ic_star".toPNG),
                            color: AppColors.secondColor,
                            size: 11,
                          ),
                        ),
                      ],
                    ),
                    5.verticalSpace,
                    ExtraCredit(
                      extra: PurchaseHelper.instance.getExtraForId(
                          Purchase.subscription, productDetails.id),
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${productDetails.currencySymbol} ${productDetails.rawPrice}",
                            style: TextStyle(
                              color: AppColors.secondColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            LocaleKeys.everyMonth.tr(),
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: HexColor("#88C196"),
                  ),
                  child: Text(
                    isActive(context)
                        ? LocaleKeys.active.tr()
                        : LocaleKeys.sub.tr(),
                    style: TextStyle(
                      color: AppColors.secondColor,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool isActive(BuildContext context) {
    for (var element in context.watch<PurchaseCubit>().state.purchases) {
      if (element.productID == productDetails.id) {
        return true;
      }
    }
    return false;
  }
}
