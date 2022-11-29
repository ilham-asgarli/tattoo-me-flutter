import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tattoo/core/router/core/router_service.dart';
import 'package:tattoo/utils/logic/constants/locale/locale_keys.g.dart';
import 'package:tattoo/utils/logic/constants/router/router_constants.dart';
import 'package:tattoo/utils/ui/constants/colors/app_colors.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/widget_extension.dart';

class MoreView extends StatefulWidget {
  const MoreView({Key? key}) : super(key: key);

  @override
  State<MoreView> createState() => _MoreViewState();
}

class _MoreViewState extends State<MoreView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          widget.dynamicVerticalSpace(context, 0.1),
          const FaIcon(
            FontAwesomeIcons.user,
            size: 50,
          ),
          widget.verticalSpace(20),
          buildSignUpOrSignIn(),
          Padding(
            padding: context.paddingLow,
            child: Text(
              LocaleKeys.moreDescription.tr(),
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ),
          widget.dynamicVerticalSpace(context, 0.1),
          buildFeatures(),
        ],
      ),
    );
  }

  Widget buildSignUpOrSignIn() {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0),
        fixedSize: MaterialStateProperty.all<Size>(
          Size(context.width / 1.5, 40),
        ),
        backgroundColor:
            MaterialStateProperty.all<Color>(AppColors.secondColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      onPressed: () {
        RouterService.instance.pushNamed(path: RouterConstants.signUpIn);
      },
      child: Text(
        LocaleKeys.signUpOrSignIn.tr(),
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget buildFeatures() {
    return Padding(
      padding: context.paddingLow,
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 10,
        runSpacing: 10,
        direction: Axis.horizontal,
        children: [
          buildFeature(
            FontAwesomeIcons.handshake,
            LocaleKeys.privacyPolicy.tr(),
          ),
          buildFeature(
            FontAwesomeIcons.rotate,
            LocaleKeys.checkUpdates.tr(),
          ),
          buildFeature(
            FontAwesomeIcons.envelope,
            LocaleKeys.reportMistake.tr(),
          ),
        ],
      ),
    );
  }

  Widget buildFeature(IconData icon, String text) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.tertiary,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      width: context.width / 2 - 10 - 50,
      height: context.width / 2 - 10 - 50,
      child: Padding(
        padding: context.paddingLow,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon),
            widget.verticalSpace(15),
            Text(
              text,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
