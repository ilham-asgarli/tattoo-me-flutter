import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tattoo/core/base/view-models/base_view_model.dart';
import 'package:tattoo/core/router/core/router_service.dart';
import 'package:tattoo/domain/models/auth/user_model.dart';

import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';

class SignUpInViewModel extends BaseViewModel {
  SignUpInViewModel({required super.context});

  UserModel userModel = UserModel(email: "", password: "");

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

  void signInUp() {
    SignState signState = context.read<SignBloc>().state;

    if (signState is SignIn || signState is SignUp || signState is SignedUp) {
      BlocProvider.of<SignBloc>(context)
          .add(SigningEvent(userModel: userModel));

      Future.delayed(const Duration(seconds: 3)).then((value) {
        BlocProvider.of<SignBloc>(context)
            .add(SignedEvent(userModel: userModel));
        RouterService.instance.pop();
      });
    }
  }

  void changeSign() {
    SignState signState = context.read<SignBloc>().state;
    if (signState is SignIn || signState is SignUp || signState is SignedUp) {
      BlocProvider.of<SignBloc>(context)
          .add(ChangeSignEvent(userModel: signState.userModel));
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
