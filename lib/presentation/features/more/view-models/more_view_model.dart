import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tattoo/core/base/view-models/base_view_model.dart';

import '../../../../core/router/core/router_service.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';

class MoreViewModel extends BaseViewModel {
  MoreViewModel({required super.context});

  signInUpOut() {
    SignState signState = context.read<SignBloc>().state;
    if (signState is SignedIn) {
      BlocProvider.of<SignBloc>(context).add(SignOutEvent());
    } else {
      RouterService.instance.pushNamed(path: RouterConstants.signUpIn);
    }
  }
}
