import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tattoo/core/base/view-models/base_view_model.dart';

import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';

class SignUpInViewModel extends BaseViewModel {
  SignUpInViewModel({required super.context});

  changeSign() {
    BlocProvider.of<SignBloc>(context).add(ChangeSignEvent());
  }

  Future<bool> onBackPressed(SignState state) async {
    if (state is SignUp) {
      changeSign();
      return false;
    } else {
      Navigator.pop(context);
      return true;
    }
  }
}
