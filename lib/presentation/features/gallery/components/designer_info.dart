import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../backend/utils/constants/app/app_constants.dart';
import '../../../../core/extensions/num_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import 'designer_card.dart';

class DesignerInfo extends StatelessWidget {
  final int count;

  const DesignerInfo({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    var active = count > -1;

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
              Text(
                LocaleKeys.tattooDesigner.tr(),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              20.verticalSpace,
              DesignerCard(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      active ? LocaleKeys.online.tr() : LocaleKeys.offline.tr(),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    if (active)
                      Row(
                        children: [
                          10.horizontalSpace,
                          CircleAvatar(
                            radius: 3,
                            backgroundColor: HexColor("#2df661"),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              15.verticalSpace,
              DesignerCard(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IntrinsicWidth(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            active
                                ? LocaleKeys.approximateWaitingTime.tr()
                                : LocaleKeys.offlineDescription.tr(),
                            style: const TextStyle(
                              fontSize: 9,
                            ),
                          ),
                          if (active) ...[
                            10.horizontalSpace,
                            Text(
                              "${(count + 1) * AppConstants.oneDesignDuration.inMinutes} ${LocaleKeys.minute.tr()}",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            10.horizontalSpace,
                          ]
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.access_time,
                      size: 15,
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
