import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/num_extension.dart';
import '../../../../utils/logic/constants/enums/app_enums.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';
import '../../../../utils/logic/state/cubit/settings/settings_cubit.dart';
import 'earn_dialog.dart';
import 'free_credits_item.dart';

class EarnTab extends StatelessWidget {
  const EarnTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: context.paddingLowHorizontal,
            child: Text(
              LocaleKeys.freeCreditsDescription.tr(),
              style: const TextStyle(
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          20.verticalSpace,
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: EarnCredit.values.map((item) {
              return SizedBox(
                width: context.width / 2 - 15,
                child: InkWell(
                  onTap: item == EarnCredit.comment
                      ? () {
                          bool awardedReview = context
                                  .read<SettingsCubit>()
                                  .state
                                  .settingsModel
                                  ?.awardedReview ??
                              false;

                          bool isFirstOrderInsufficientBalance = context
                                  .read<SignBloc>()
                                  .state
                                  .userModel
                                  .isFirstOrderInsufficientBalance ??
                              false;

                          if (awardedReview &&
                              isFirstOrderInsufficientBalance) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return EarnDialog(
                                  userId: context
                                      .read<SignBloc>()
                                      .state
                                      .userModel
                                      .id,
                                );
                              },
                            );
                          }
                        }
                      : null,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                  child: FreeCreditsItem(
                    earnCredit: item,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
