import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

import '../../../../core/extensions/int_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../view-models/retouch_view_model.dart';

class RetouchTimer extends StatefulWidget {
  const RetouchTimer({super.key});

  @override
  State<RetouchTimer> createState() => _RetouchTimerState();
}

class _RetouchTimerState extends State<RetouchTimer> {
  RetouchViewModel viewModel = RetouchViewModel();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: viewModel.computeEndTime(context),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return CountdownTimer(
            onEnd: () {
              setState(() {
                viewModel.computeEndTime(context);
              });
            },
            endTime: viewModel.endTime,
            widgetBuilder: (context, time) {
              return RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: LocaleKeys.approximateTimeLeft.tr(),
                    ),
                    TextSpan(
                      text:
                          "    ${((time?.days ?? 0) > 0) ? " ${time?.days} ${LocaleKeys.day.tr()}" : ""} ${time?.hours?.toFixed(2).concatIfNotEmpty(":") ?? ""}${time?.min.toFixed(2, visibility: true).concatIfNotEmpty(":") ?? "00:"}${time?.sec.toFixed(2) ?? "00"}",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
