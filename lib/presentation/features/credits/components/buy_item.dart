import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/num_extension.dart';
import '../../../../utils/logic/constants/enums/purchase_enums.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/helpers/purchase/purchase_helper.dart';
import '../../../../utils/ui/constants/colors/app_colors.dart';
import 'advantageous.dart';
import 'extra_credit.dart';

class BuyItem extends StatelessWidget {
  final ProductDetails productDetails;

  const BuyItem({super.key, required this.productDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HexColor("#C9F2CA"),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Stack(
        children: [
          Advantageous(
            purchase: Purchase.inAppProduct,
            isAdvantageous: productDetails.id ==
                PurchaseHelper.instance.getAllIds(Purchase.inAppProduct)[3],
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          PurchaseHelper.instance
                              .getCreditsForId(
                                  Purchase.inAppProduct, productDetails.id)
                              .toString(),
                          style: TextStyle(
                            color: AppColors.mainColor,
                            fontSize: 13,
                          ),
                        ),
                        Icon(
                          Icons.star_border_rounded,
                          size: 16,
                          color: AppColors.mainColor,
                        ),
                      ],
                    ),
                    10.verticalSpace,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          productDetails.currencySymbol,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.mainColor,
                          ),
                        ),
                        3.horizontalSpace,
                        Text(
                          "${productDetails.rawPrice}",
                          style: TextStyle(
                            fontFamily: "Neue-Haas-Display",
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.mainColor,
                          ),
                        ),
                      ],
                    ),
                    10.verticalSpace,
                    ExtraCredit(
                      extra: PurchaseHelper.instance.getExtraForId(
                        Purchase.inAppProduct,
                        productDetails.id,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: context.paddingLow,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: HexColor("#69B680"),
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(5)),
                ),
                child: Text(
                  LocaleKeys.buy.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
