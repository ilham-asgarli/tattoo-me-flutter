import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'advantageous.dart';

import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/ui/constants/colors/app_colors.dart';

class SubscribeItem extends StatelessWidget {
  final Map<String, dynamic> subscriptionMap;

  const SubscribeItem({
    Key? key,
    required this.subscriptionMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: Stack(
        children: [
          Advantageous(
            isAdvantageous: subscriptionMap["isAdvantageous"],
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${subscriptionMap["count"]}",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "₺ ${subscriptionMap["price"]}",
                      style: TextStyle(
                        color: AppColors.secondColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  LocaleKeys.sub.tr(),
                  style: TextStyle(
                    color: AppColors.secondColor,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
