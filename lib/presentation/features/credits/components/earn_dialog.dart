import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/num_extension.dart';
import '../../../../domain/models/auth/user_model.dart';
import '../../../../domain/repositories/review/implemantations/review_repository.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/helpers/in-app-review/in_app_review_helper.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';
import '../../../components/credit_icon.dart';

class EarnDialog extends StatelessWidget {
  const EarnDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.normalValue * 1.3,
          horizontal: context.normalValue,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.earnCreditDescription_comment.tr(args: ["30"]),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            (context.normalValue * 1.3).verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const CreditIcon(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor("#636363"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);

                    await InAppReviewHelper.instance.request();
                    if (context.mounted) {
                      await ReviewRepository().makeReview(UserModel(
                        id: context.read<SignBloc>().state.userModel.id,
                      ));
                    }
                  },
                  child: Text(
                    LocaleKeys.goStore.tr(),
                  ),
                ),
                const CreditIcon(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
