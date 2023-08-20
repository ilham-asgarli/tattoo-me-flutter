import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../utils/logic/constants/enums/purchase_enums.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/helpers/purchase/purchase_helper.dart';
import '../../../../utils/logic/state/cubit/purchase/purchase_cubit.dart';
import '../../../../utils/ui/constants/colors/app_colors.dart';
import 'subscribe_item.dart';

class Subscribe extends StatelessWidget {
  const Subscribe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ProductDetails> products =
        context.watch<PurchaseCubit>().state.products;
    Iterable<ProductDetails> productsIterable = products.where((element) {
      return PurchaseHelper.instance
          .containsElementWithId(Purchase.subscription, element.id);
    });

    products = productsIterable.toList();
    products.sort(
      (a, b) {
        return PurchaseHelper.instance
            .getCreditsForId(Purchase.subscription, a.id)!
            .compareTo(PurchaseHelper.instance
                .getCreditsForId(Purchase.subscription, b.id)!);
      },
    );

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      itemCount: products.length + 1,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: HexColor("#2C7E4E"),
            borderRadius: index == 0
                ? const BorderRadius.vertical(
                    top: Radius.circular(10),
                  )
                : index == products.length
                    ? const BorderRadius.vertical(
                        bottom: Radius.circular(10),
                      )
                    : null,
          ),
          child: index == 0
              ? buildSubHeader()
              : InkWell(
                  onTap: () {
                    PurchaseHelper.instance.onTap(context, products[index - 1]);
                  },
                  borderRadius: index == products.length
                      ? const BorderRadius.vertical(
                          bottom: Radius.circular(10),
                        )
                      : null,
                  child: SubscribeItem(
                    productDetails: products[index - 1],
                  ),
                ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          color: HexColor("#CBF1CA"),
          height: 0,
          thickness: 0.3,
        );
      },
    );
  }

  Widget buildSubHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            LocaleKeys.packets.tr(),
            style: TextStyle(
              color: AppColors.secondColor,
              fontSize: 17,
            ),
          ),
          Text(
            LocaleKeys.monthlySub.tr(),
            style: TextStyle(
              color: AppColors.secondColor,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
