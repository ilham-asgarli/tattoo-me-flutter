import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tattoo/domain/repositories/auth/implementations/auth_repository.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../core/base/models/base_success.dart';
import '../../../../core/base/view-models/base_view_model.dart';
import '../../../../core/router/core/router_service.dart';
import '../../../../domain/models/auth/user_model.dart';
import '../../../../domain/usecases/auth/implementations/auth_usecase.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';
import '../components/delete_account_dialog.dart';

class MoreViewModel extends BaseViewModel {
  AuthUseCase authUseCase = AuthUseCase();

  Future<void> signInUpOut(BuildContext context) async {
    SignState signState = context.read<SignBloc>().state;

    if (signState is SignedIn) {
      BlocProvider.of<SignBloc>(context).add(const SigningOutEvent());

      BaseResponse<UserModel> baseResponse = await authUseCase.signOut();

      if (baseResponse is BaseSuccess<UserModel>) {
        BlocProvider.of<SignBloc>(context)
            .add(SignOutEvent(signOutUserModel: baseResponse.data!));
      }
    } else {
      RouterService.instance.pushNamed(path: RouterConstants.signUpIn);
    }
  }

  Future<void> showDeleteAccountDialog(
    BuildContext context,
  ) async {
    await showDialog(
      context: context,
      builder: (_) {
        return DeleteAccountDialog(
          buildContext: context,
        );
      },
    );
  }
}
