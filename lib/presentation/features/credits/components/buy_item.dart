import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';

class BuyItem extends StatelessWidget {
  final Map<String, Object> buyMap;

  const BuyItem({Key? key, required this.buyMap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HexColor("#77BD52"),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: context.paddingLow,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(buyMap["count"].toString()),
                    const Icon(
                      Icons.star,
                      size: 20,
                    ),
                  ],
                ),
                Text(
                  "₺ ${buyMap["price"]}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  LocaleKeys.noExtraCredits.tr(),
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: context.paddingLow,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            ),
            child: Text(
              LocaleKeys.buy.tr(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
