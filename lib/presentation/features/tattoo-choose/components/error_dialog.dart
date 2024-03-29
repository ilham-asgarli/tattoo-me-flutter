import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/widget_extension.dart';
import '../../../../core/router/core/router_service.dart';
import '../../../../domain/models/auth/user_model.dart';
import '../../../../domain/repositories/review/implemantations/review_repository.dart';
import '../../../../utils/logic/constants/enums/app_enums.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/logic/helpers/app-review/app_review_helper.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';
import '../../../../utils/logic/state/cubit/settings/settings_cubit.dart';
import '../../../../utils/ui/constants/colors/app_colors.dart';
import '../../../components/dialog_action_button.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  final bool insufficientBalance;
  final BuildContext buildContext;
  final bool? isAwardedReview;

  const ErrorDialog({
    super.key,
    this.message = "",
    this.insufficientBalance = false,
    required this.buildContext,
    this.isAwardedReview,
  });

  @override
  Widget build(BuildContext context) {
    UserModel userModel = context.read<SignBloc>().state.userModel;

    bool isAwardedReviewVisible = isAwardedReview ??
        (userModel.isFirstOrderInsufficientBalance ?? true) &&
            (context.read<SettingsCubit>().state.settingsModel?.awardedReview ??
                false);

    String text = insufficientBalance
        ? isAwardedReviewVisible
            ? LocaleKeys.insufficientBalanceReview.tr()
            : LocaleKeys.insufficientBalanceDescription.tr()
        : message;

    return AlertDialog(
      backgroundColor: AppColors.secondColor,
      actionsPadding: EdgeInsets.zero,
      contentPadding: context.paddingMedium,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        insufficientBalance
            ? Row(
                children: [
                  DialogActionButton(
                    onPressed: () {
                      Navigator.pop(context);
                      RouterService.instance.pushNamed(
                        path: RouterConstants.credits,
                        data: CreditsViewType.insufficient,
                      );
                    },
                    child: Text(
                      LocaleKeys.buyCredit.tr(),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  Visibility(
                    visible: isAwardedReviewVisible,
                    child: DialogActionButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await AppReviewHelper.instance.openStore();
                        await ReviewRepository().makeReview(UserModel(
                          id: buildContext.read<SignBloc>().state.userModel.id,
                        ));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            LocaleKeys.evaluate.tr(),
                            style: const TextStyle(color: Colors.black),
                          ),
                          context.widget.horizontalSpace(10),
                          FaIcon(
                            FontAwesomeIcons.star,
                            size: 20,
                            color: Colors.amber.withOpacity(0.6),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  DialogActionButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      LocaleKeys.close.tr(),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
