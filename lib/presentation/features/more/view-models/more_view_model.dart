import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tattoo/core/base/view-models/base_view_model.dart';
import 'package:tattoo/domain/repositories/auth/implementations/auth_repository.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../core/base/models/base_success.dart';
import '../../../../core/router/core/router_service.dart';
import '../../../../domain/repositories/auth/implementations/anonymous_auth_repository.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';

class MoreViewModel extends BaseViewModel {
  MoreViewModel({required super.context});

  Future<void> signInUpOut(bool mounted) async {
    SignState signState = context.read<SignBloc>().state;

    if (signState is SignedIn) {
      BlocProvider.of<SignBloc>(context).add(const SignOutEvent());

      AuthRepository authRepository = AuthRepository();
      await authRepository.signOut();

      AnonymousAuthRepository anonymousAuth = AnonymousAuthRepository();
      BaseResponse responseModel = await anonymousAuth.signInAnonymously();

      if (responseModel is BaseSuccess) {
        if (mounted) {
          BlocProvider.of<SignBloc>(context).add(const SignOutEvent());
        }
      }
    } else {
      RouterService.instance.pushNamed(path: RouterConstants.signUpIn);
    }
  }
}
