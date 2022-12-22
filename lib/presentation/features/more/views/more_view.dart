import 'package:centered_singlechildscrollview/centered_singlechildscrollview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:tattoo/presentation/features/more/view-models/more_view_model.dart';
import 'package:tattoo/utils/logic/constants/locale/locale_keys.g.dart';
import 'package:tattoo/utils/logic/state/bloc/sign/sign_bloc.dart';
import 'package:tattoo/utils/ui/constants/colors/app_colors.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/widget_extension.dart';
import '../../../widgets/fractionally_sized_circular_progress_indicator.dart';

class MoreView extends StatelessWidget {
  final MoreViewModel viewModel = MoreViewModel();

  MoreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: CenteredSingleChildScrollView(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          context.widget.dynamicVerticalSpace(context, 0.1),
          const FaIcon(
            FontAwesomeIcons.user,
            size: 50,
          ),
          context.widget.verticalSpace(20),
          buildSignUpOrSignIn(context),
          Padding(
            padding: context.paddingLow,
            child: Text(
              LocaleKeys.moreDescription.tr(),
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ),
          context.widget.dynamicVerticalSpace(context, 0.1),
          buildFeatures(context),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar();
  }

  Widget buildSignUpOrSignIn(BuildContext context) {
    SignState signState = context.watch<SignBloc>().state;

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
      onPressed: () async {
        await viewModel.signInUpOut(context);
      },
      child: (signState is SigningOut)
          ? const FractionallySizedCircularProgressIndicator(
              factor: 0.5,
              color: Colors.black,
            )
          : Text(
              signState is SignedIn
                  ? LocaleKeys.signOut.tr()
                  : LocaleKeys.signUpOrSignIn.tr(),
              style: const TextStyle(color: Colors.black),
            ),
    );
  }

  Widget buildFeatures(BuildContext context) {
    return Padding(
      padding: context.paddingLow,
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 10,
        runSpacing: 10,
        direction: Axis.horizontal,
        children: [
          buildFeature(
            context,
            FontAwesomeIcons.handshake,
            LocaleKeys.privacyPolicy.tr(),
            () {},
          ),
          buildFeature(
            context,
            FontAwesomeIcons.rotate,
            LocaleKeys.checkUpdates.tr(),
            checkForUpdates,
          ),
          buildFeature(
            context,
            FontAwesomeIcons.envelope,
            LocaleKeys.reportMistake.tr(),
            sendErrorMail,
          ),
        ],
      ),
    );
  }

  Widget buildFeature(
      BuildContext context, IconData icon, String text, Function() onTap) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      onTap: onTap,
      child: Ink(
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
              context.widget.verticalSpace(15),
              Text(
                text,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendErrorMail() async {
    final Email email = Email(
      subject: LocaleKeys.errorMailSubject.tr(),
      body: LocaleKeys.errorMailBody.tr(),
      recipients: [LocaleKeys.errorMailRecipients.tr(gender: "0")],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }

  Future<void> checkForUpdates() async {
    await StoreRedirect.redirect();
  }
}
