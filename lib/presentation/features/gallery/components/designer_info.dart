import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../backend/utils/constants/app/app_constants.dart';
import '../../../../core/extensions/num_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/state/bloc/designer-status/designer_status_bloc.dart';
import 'designer_card.dart';

class DesignerInfo extends StatelessWidget {
  const DesignerInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DesignerStatusBloc, DesignerStatusState>(
      builder: (context, state) {
        bool active = state is HasDesigner;
        int count = 0;

        if (active) {
          count = state.minRequestCount;
        }

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
                          active
                              ? LocaleKeys.online.tr()
                              : LocaleKeys.offline.tr(),
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          children: [
                            10.horizontalSpace,
                            CircleAvatar(
                              radius: 4.5,
                              backgroundColor: active
                                  ? HexColor("#2df661")
                                  : HexColor("#707070"),
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
                                LocaleKeys.approximateWaitingTime.tr(),
                                style: const TextStyle(
                                  fontSize: 9,
                                ),
                              ),
                              5.horizontalSpace,
                              Text(
                                active
                                    ? "${(count + 1) * AppConstants.oneDesignDuration.inMinutes} ${LocaleKeys.minute.tr()}"
                                    : "${24} ${LocaleKeys.hour.tr()}",
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              4.horizontalSpace,
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
      },
    );
  }
}
