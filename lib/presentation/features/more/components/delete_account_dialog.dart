import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../core/base/models/base_success.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/router/core/router_service.dart';
import '../../../../domain/usecases/auth/implementations/auth_usecase.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';
import '../../../../utils/ui/constants/colors/app_colors.dart';
import '../../../components/dialog_action_button.dart';

class DeleteAccountDialog extends StatelessWidget {
  final BuildContext buildContext;

  const DeleteAccountDialog({
    Key? key,
    required this.buildContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.secondColor,
      actionsPadding: EdgeInsets.zero,
      contentPadding: context.paddingMedium,
      title: Text(
        LocaleKeys.deleteAccount.tr(),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.deleteAccountDescription.tr(),
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
        Row(
          children: [
            DialogActionButton(
              onPressed: () {
                Navigator.pop(context);
                deleteAccount(buildContext);
              },
              child: Text(
                LocaleKeys.yes.tr(),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            DialogActionButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: Text(
                LocaleKeys.no.tr(),
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        )
      ],
    );
  }

  Future<void> deleteAccount(BuildContext context) async {
    SignState signState = context.read<SignBloc>().state;

    if (signState is SignedIn) {
      BlocProvider.of<SignBloc>(context).add(const SigningOutEvent());

      AuthUseCase authUseCase = AuthUseCase();
      BaseResponse baseResponse =
          await authUseCase.deleteAccount(signState.userModel.id!);

      if (baseResponse is BaseSuccess) {
        BlocProvider.of<SignBloc>(context)
            .add(SignOutEvent(signOutUserModel: baseResponse.data!));
      }
    } else {
      RouterService.instance.pushNamed(path: RouterConstants.signUpIn);
    }
  }
}
