import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../backend/utils/constants/app/app_constants.dart';
import '../../../../core/extensions/num_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import 'designer_card.dart';

class DesignerInfo extends StatelessWidget {
  final int min;

  const DesignerInfo({
    super.key,
    required this.min,
  });

  @override
  Widget build(BuildContext context) {
    var active = min > -1;

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
                      active ? LocaleKeys.online.tr() : LocaleKeys.offline.tr(),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    if (active)
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
                        active
                            ? LocaleKeys.approximateWaitingTime.tr(args: [
                                ((min + 1) *
                                        AppConstants
                                            .oneDesignDuration.inMinutes)
                                    .toString()
                              ])
                            : LocaleKeys.offlineDescription.tr(),
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
