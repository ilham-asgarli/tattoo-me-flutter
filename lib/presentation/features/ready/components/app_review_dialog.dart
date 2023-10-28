import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../backend/utils/constants/app/app_constants.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/num_extension.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/helpers/app-review/app_review_helper.dart';

class AppReviewDialog extends StatelessWidget {
  final String? userId;

  const AppReviewDialog({
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
              LocaleKeys.inAppReviewDescription.tr(args: [
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);

                AppReviewHelper.instance.requestReview();
                /*await Future.delayed(const Duration(seconds: 20))
                    .then((value) async {
                  await ReviewRepository().makeReview(UserModel(
                    id: userId,
                  ));
                });*/
              },
              child: Text(
                LocaleKeys.evaluate.tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
