import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/num_extension.dart';
import '../../../../domain/models/auth/user_model.dart';
import '../../../../domain/repositories/review/implemantations/review_repository.dart';
import '../../../../utils/logic/constants/app/app_constants.dart';
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
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 30.0, vertical: 24.0),
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
              LocaleKeys.inAppReviewTitle.tr(),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                height: 1.5,
                fontSize: 15,
              ),
            ),
            20.verticalSpace,
            Text(
              LocaleKeys.inAppReviewDescription.tr(),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                height: 1.5,
                fontSize: 14.5,
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

                if (Platform.isIOS) {
                  Uri url = Uri.parse(
                      "https://apps.apple.com/us/app/twitter/id${AppConstants.iOSId}?action=write-review");
                  launchUrl(url);
                } else {
                  AppReviewHelper.instance.requestReview();
                }
                await Future.delayed(const Duration(seconds: 5))
                    .then((value) async {
                  await ReviewRepository().makeReview(UserModel(
                    id: userId,
                  ));
                });
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
