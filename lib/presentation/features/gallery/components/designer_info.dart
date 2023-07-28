import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../core/extensions/num_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import 'designer_card.dart';

class DesignerInfo extends StatelessWidget {
  const DesignerInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 2,
          child: Image.asset("ic_designer".toPNG),
        ),
        20.horizontalSpace,
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DesignerCard(
                child: Text(
                  LocaleKeys.tattooDesigner.tr(),
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              3.verticalSpace,
              DesignerCard(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      LocaleKeys.online.tr(),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Row(
                      children: [
                        5.horizontalSpace,
                        CircleAvatar(
                          radius: 3,
                          backgroundColor: HexColor("#2df661"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              3.verticalSpace,
              DesignerCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        /*LocaleKeys.offlineDescription.tr()*/
                        LocaleKeys.approximateWaitingTime.tr(args: ["10"]),
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.access_time,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
