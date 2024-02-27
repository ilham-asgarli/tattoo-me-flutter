import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/extensions/widget_extension.dart';

import '../../../../core/router/core/router_service.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/ui/constants/colors/app_colors.dart';

class IosStoreArea extends StatelessWidget {
  const IosStoreArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: Platform.isIOS,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  RouterService.instance.pushNamed(
                    path: RouterConstants.privacyPolicy,
                  );
                },
                child: Text(
                  LocaleKeys.privacyPolicy.tr(),
                  style: TextStyle(color: AppColors.secondColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  RouterService.instance.pushNamed(
                    path: RouterConstants.termOfUse,
                  );
                },
                child: Text(
                  LocaleKeys.termOfUse.tr(),
                  style: TextStyle(color: AppColors.secondColor),
                ),
              ),
            ],
          ),
          context.widget.verticalSpace(20),
        ],
      ),
    );
  }
}
