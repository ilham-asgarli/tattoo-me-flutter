import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/int_extension.dart';
import '../../../../core/extensions/num_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/state/cubit/settings/settings_cubit.dart';
import '../../../components/my_countdown_timer.dart';

class WaitingTime extends StatefulWidget {
  const WaitingTime({super.key});

  @override
  State<WaitingTime> createState() => _WaitingTimeState();
}

class _WaitingTimeState extends State<WaitingTime> {
  @override
  Widget build(BuildContext context) {
    return MyCountDownTimer(
      onEnd: () {
        setState(() {});
      },
      endTime: context
              .watch<SettingsCubit>()
              .state
              .settingsModel
              ?.activeDesignerTime ??
          DateTime.now().add(const Duration(seconds: 3)).millisecondsSinceEpoch,
      widgetBuilder: (t) {
        int? days = t?.inDays;
        int? hours = t?.inHours;
        int? min = t?.inMinutes;
        int? sec = t?.inSeconds;

        return Row(
          children: [
            if (days == null) 5.horizontalSpace,
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        "${((days ?? 0) > 0) ? " $days ${LocaleKeys.day.tr()}" : ""} ${hours?.toFixed(2).concatIfNotEmpty(":") ?? ""}${min.toFixed(2, visibility: true).concatIfNotEmpty(":") ?? "00:"}${sec.toFixed(2) ?? "00"}",
                    style: const TextStyle(
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            if (days == null) 5.horizontalSpace,
          ],
        );
      },
    );
  }
}
