import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tattoo/presentation/features/more/view-models/more_view_model.dart';
import 'package:tattoo/utils/logic/constants/locale/locale_keys.g.dart';
import 'package:tattoo/utils/logic/state/bloc/sign/sign_bloc.dart';
import 'package:tattoo/utils/ui/constants/colors/app_colors.dart';

import '../../../../core/base/views/base_view.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/widget_extension.dart';
import '../../../widgets/fractionally_sized_circular_progress_indicator.dart';

class MoreView extends View<MoreViewModel> {
  MoreView({super.key}) : super(viewModelBuilder: () => MoreViewModel());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          viewModel.widget.dynamicVerticalSpace(context, 0.1),
          const FaIcon(
            FontAwesomeIcons.user,
            size: 50,
          ),
          viewModel.widget.verticalSpace(20),
          buildSignUpOrSignIn(),
          Padding(
            padding: viewModel.context.paddingLow,
            child: Text(
              LocaleKeys.moreDescription.tr(),
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ),
          viewModel.widget.dynamicVerticalSpace(context, 0.1),
          buildFeatures(),
        ],
      ),
    );
  }

  Widget buildSignUpOrSignIn() {
    SignState signState = viewModel.context.watch<SignBloc>().state;

    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0),
        fixedSize: MaterialStateProperty.all<Size>(
          Size(viewModel.context.width / 1.5, 40),
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
        await viewModel.signInUpOut(viewModel.mounted);
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

  Widget buildFeatures() {
    return Padding(
      padding: viewModel.context.paddingLow,
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
      width: viewModel.context.width / 2 - 10 - 50,
      height: viewModel.context.width / 2 - 10 - 50,
      child: Padding(
        padding: viewModel.context.paddingLow,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon),
            viewModel.widget.verticalSpace(15),
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
