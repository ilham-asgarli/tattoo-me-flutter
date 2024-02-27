import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../utils/logic/constants/enums/purchase_enums.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';

class Advantageous extends StatelessWidget {
  final Purchase purchase;
  final bool? isAdvantageous;

  const Advantageous({
    super.key,
    this.isAdvantageous,
    required this.purchase,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isAdvantageous ?? false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.only(
            bottomRight: const Radius.circular(10),
            topLeft: Radius.circular(purchase == Purchase.inAppProduct ? 5 : 0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Text(
            LocaleKeys.advantageous.tr(),
            style: const TextStyle(
              fontSize: 7,
            ),
          ),
        ),
      ),
    );
  }
}
