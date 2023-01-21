import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tattoo/core/constants/app/global_key_constants.dart';
import '../../../../core/base/models/base_error.dart';
import '../../../../core/base/models/base_response.dart';
import '../../../../core/base/models/base_success.dart';
import '../../../../core/base/view-models/base_view_model.dart';
import '../../../../core/router/core/router_service.dart';
import '../../../../domain/models/auth/user_model.dart';
import '../../../../domain/repositories/auth/implementations/email_auth_repository.dart';

import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';

class SignUpInViewModel extends BaseViewModel {
  UserModel userModel = UserModel();
  bool isPasswordVisible = false;

  void onSavedEmail(String? value) {
    if (value != null) {
      userModel.email = value;
    }
  }

  void onSavedPassword(String? value) {
    if (value != null) {
      userModel.password = value;
    }
  }

  Future<void> signInUp(BuildContext context, bool mounted) async {
    SignState signState = context.read<SignBloc>().state;

    if (signState is SignIn || signState is SignUp || signState is SignedUp) {
      BlocProvider.of<SignBloc>(context).add(const SigningEvent());

      EmailAuthRepository emailAuthRepository = EmailAuthRepository();
      if (signState is SignUp) {
        BaseResponse<UserModel> baseResponse =
            await emailAuthRepository.signUpWithEmailAndPassword(userModel);
        if (mounted) {
          closePageAfterSign(context, mounted, baseResponse);
        }
      } else {
        BaseResponse<UserModel> baseResponse =
            await emailAuthRepository.signInWithEmailAndPassword(userModel);
        if (mounted) {
          closePageAfterSign(context, mounted, baseResponse);
        }
      }
    }
  }

  void closePageAfterSign(BuildContext context, bool mounted,
      BaseResponse<UserModel> baseResponse) {
    if (baseResponse is BaseError) {
      BlocProvider.of<SignBloc>(context).add(const SignErrorEvent());
      return;
    }

    if (mounted &&
        baseResponse is BaseSuccess<UserModel> &&
        baseResponse.data != null) {
      BlocProvider.of<SignBloc>(context)
          .add(SignedEvent(signedUserModel: baseResponse.data!));
      RouterService.instance.pop();

      if (baseResponse.message?.isNotEmpty ?? false) {
        GlobalKeyConstants.scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(baseResponse.message ?? ""),
          ),
        );
      }
    }
  }

  void changeSign(BuildContext context) {
    SignState signState = context.read<SignBloc>().state;
    if (signState is SignIn || signState is SignUpState) {
      BlocProvider.of<SignBloc>(context).add(const ChangeSignEvent());
    }
  }

  Future<bool> onBackPressed(BuildContext context) async {
    SignState signState = context.read<SignBloc>().state;

    if (signState is SigningIn || signState is SigningUp) {
      return false;
    }

    if (signState is SignUpState) {
      changeSign(context);
      return false;
    } else {
      Navigator.pop(context);
      return true;
    }
  }
}
