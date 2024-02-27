import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../utils/logic/constants/enums/purchase_enums.dart';
import '../../../../utils/logic/helpers/purchase/purchase_helper.dart';
import '../../../../utils/logic/state/cubit/purchase/purchase_cubit.dart';
import 'buy_item.dart';

class Buy extends StatelessWidget {
  const Buy({super.key});

  @override
  Widget build(BuildContext context) {
    List<ProductDetails> products =
        context.watch<PurchaseCubit>().state.products;
    Iterable<ProductDetails> productsIterable = products.where((element) {
      return PurchaseHelper.instance
          .containsElementWithId(Purchase.inAppProduct, element.id);
    });

    products = productsIterable.toList();
    products.sort(
      (a, b) {
        return PurchaseHelper.instance
            .getCreditsForId(Purchase.inAppProduct, a.id)!
            .compareTo(PurchaseHelper.instance
                .getCreditsForId(Purchase.inAppProduct, b.id)!);
      },
    );

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: products.map((item) {
        return SizedBox(
          width: context.width / 2 - 15,
          child: InkWell(
            onTap: () {
              PurchaseHelper.instance.onTap(context, item);
            },
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
            child: BuyItem(
              productDetails: item,
            ),
          ),
        );
      }).toList(),
    );
  }
}
