import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tattoo/presentation/features/credits/components/subscribe_item.dart';

import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/constants/purchase/purchase_constants.dart';
import '../../../../utils/logic/helpers/purchase/purchase_helper.dart';
import '../../../../utils/logic/state/cubit/purchase/purchase_cubit.dart';
import '../../../../utils/ui/constants/colors/app_colors.dart';

class Subscribe extends StatelessWidget {
  const Subscribe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ProductDetails> products =
        context.watch<PurchaseCubit>().state.products;
    Iterable<ProductDetails> productsIterable = products.where((element) {
      return PurchaseConstants.subscriptions.keys.contains(element.id);
    });

    products = productsIterable.toList();
    products.sort(
      (a, b) {
        return PurchaseConstants.subscriptions[a.id]!
            .compareTo(PurchaseConstants.subscriptions[b.id]!);
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
            color: Colors.lightGreen.withAlpha(150),
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
        return const Divider(
          color: Colors.green,
          height: 0,
        );
      },
    );
  }

  ListTile buildSubHeader() {
    return ListTile(
      leading: Text(
        LocaleKeys.packets.tr(),
        style: TextStyle(
          color: AppColors.secondColor,
          fontSize: 18,
        ),
      ),
      trailing: Text(
        LocaleKeys.monthlySub.tr(),
        style: TextStyle(
          color: AppColors.secondColor,
          fontSize: 12,
        ),
      ),
    );
  }
}
