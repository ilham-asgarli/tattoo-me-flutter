import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tattoo/core/extensions/context_extension.dart';

import '../../../../utils/logic/constants/purchase/purchase_constants.dart';
import '../../../../utils/logic/helpers/purchase/purchase_helper.dart';
import '../../../../utils/logic/state/cubit/purchase/purchase_cubit.dart';
import 'buy_item.dart';

class Buy extends StatelessWidget {
  const Buy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ProductDetails> products =
        context.watch<PurchaseCubit>().state.products;
    Iterable<ProductDetails> productsIterable = products.where((element) {
      return PurchaseConstants.inAppProducts.keys.contains(element.id);
    });

    products = productsIterable.toList();
    products.sort(
      (a, b) {
        return PurchaseConstants.inAppProducts[a.id]!
            .compareTo(PurchaseConstants.inAppProducts[b.id]!);
      },
    );

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      direction: Axis.horizontal,
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
