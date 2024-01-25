import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/num_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../utils/logic/constants/enums/app_enums.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/extensions/earn_credit_extensions.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';
import '../../../../utils/logic/state/cubit/settings/settings_cubit.dart';
import '../../../components/credit_icon.dart';

class FreeCreditsItem extends StatelessWidget {
  final EarnCredit earnCredit;

  const FreeCreditsItem({
    super.key,
    required this.earnCredit,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      height: context.width / 3.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Ink(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: HexColor("#C9F2CA"),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${earnCredit.credit} ${LocaleKeys.credit.tr()}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          10.horizontalSpace,
                          const CreditIcon(),
                        ],
                      ),
                      if (earnCredit == EarnCredit.comment)
                        Column(
                          children: [
                            5.verticalSpace,
                            Platform.isAndroid
                                ? Image.asset(
                                    "ic_google_play".toPNG,
                                    width: 18,
                                    height: 18,
                                  )
                                : Image.asset(
                                    "ic_app_store".toPNG,
                                    width: 18,
                                    height: 18,
                                  ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Ink(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: earnCredit == EarnCredit.comment &&
                            (!(context
                                        .watch<SettingsCubit>()
                                        .state
                                        .settingsModel
                                        ?.awardedReview ??
                                    false) ||
                                !(context
                                        .watch<SignBloc>()
                                        .state
                                        .userModel
                                        .isFirstOrderInsufficientBalance ??
                                    false))
                        ? const Icon(
                            Icons.check,
                            size: 30,
                            color: Colors.black,
                          )
                        : Text(
                            earnCredit.description,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                  ),
                ),
              ),
            ],
          ),
          if (earnCredit != EarnCredit.comment)
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
                color: Colors.black.withOpacity(0.5),
              ),
            ),
        ],
      ),
    );
  }
}
