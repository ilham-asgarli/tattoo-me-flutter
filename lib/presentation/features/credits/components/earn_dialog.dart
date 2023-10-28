import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../backend/utils/constants/app/app_constants.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/num_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../domain/models/auth/user_model.dart';
import '../../../../domain/repositories/review/implemantations/review_repository.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/helpers/app-review/app_review_helper.dart';

class EarnDialog extends StatelessWidget {
  final String? userId;

  const EarnDialog({
    super.key,
    required this.userId,
  });

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
              LocaleKeys.earnCreditDescription_comment.tr(args: [
                AppConstants.tattooDesignPrice.toString(),
              ]),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            (context.normalValue * 1.3).verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  "ic_credit".toPNG,
                  width: 18,
                  height: 18,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor("#636363"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);

                    AppReviewHelper.instance.openStore();
                    await Future.delayed(const Duration(seconds: 20))
                        .then((value) async {
                      await ReviewRepository().makeReview(UserModel(
                        id: userId,
                      ));
                    });
                  },
                  child: Text(
                    LocaleKeys.goStore.tr(),
                  ),
                ),
                Image.asset(
                  "ic_credit".toPNG,
                  width: 18,
                  height: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
