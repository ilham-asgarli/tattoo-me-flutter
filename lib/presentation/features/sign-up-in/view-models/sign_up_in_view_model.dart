import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tattoo/core/base/models/base_error.dart';
import 'package:tattoo/core/base/models/base_response.dart';
import 'package:tattoo/core/base/models/base_success.dart';
import 'package:tattoo/core/base/view-models/base_view_model.dart';
import 'package:tattoo/core/router/core/router_service.dart';
import 'package:tattoo/domain/models/auth/user_model.dart';
import 'package:tattoo/domain/repositories/auth/implementations/email_auth_repository.dart';

import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';

class SignUpInViewModel extends BaseViewModel {
  UserModel userModel = UserModel();

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

  Future<void> signInUp(bool mounted) async {
    SignState signState = context.read<SignBloc>().state;

    if (signState is SignIn || signState is SignUp || signState is SignedUp) {
      BlocProvider.of<SignBloc>(context).add(const SigningEvent());

      EmailAuthRepository emailAuthRepository = EmailAuthRepository();
      if (signState is SignUp) {
        BaseResponse<UserModel> baseResponse =
            await emailAuthRepository.signUpWithEmailAndPassword(userModel);
        closePageAfterSign(mounted, baseResponse);
      } else {
        BaseResponse<UserModel> baseResponse =
            await emailAuthRepository.signInWithEmailAndPassword(userModel);
        closePageAfterSign(mounted, baseResponse);
      }
    }
  }

  void closePageAfterSign(bool mounted, BaseResponse<UserModel> baseResponse) {
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
    }
  }

  void changeSign() {
    SignState signState = context.read<SignBloc>().state;
    if (signState is SignIn || signState is SignUp || signState is SignedUp) {
      BlocProvider.of<SignBloc>(context).add(const ChangeSignEvent());
    }
  }

  Future<bool> onBackPressed() async {
    SignState signState = context.read<SignBloc>().state;

    if (signState is SigningIn || signState is SigningUp) {
      return false;
    }

    if (signState is SignUp) {
      changeSign();
      return false;
    } else {
      Navigator.pop(context);
      return true;
    }
  }
}
