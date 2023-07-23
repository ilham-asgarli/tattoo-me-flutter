import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/constants/purchase/purchase_constants.dart';
import '../../../../utils/logic/state/cubit/purchase/purchase_cubit.dart';
import '../../../../utils/ui/constants/colors/app_colors.dart';
import 'advantageous.dart';

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
          Advantageous(
            isAdvantageous: productDetails.id ==
                PurchaseConstants.subscriptions.keys.toList()[1],
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      PurchaseConstants.subscriptions[productDetails.id]
                          .toString(),
                      style: TextStyle(
                        color: AppColors.secondColor,
                        fontSize: 15,
                      ),
                    ),
                    Icon(
                      Icons.star,
                      color: AppColors.secondColor,
                      size: 20,
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${productDetails.currencySymbol} ${productDetails.rawPrice}",
                        style: TextStyle(
                          color: AppColors.secondColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  isActive(context)
                      ? LocaleKeys.active.tr()
                      : LocaleKeys.sub.tr(),
                  style: TextStyle(
                    color: AppColors.secondColor,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.end,
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
