import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tattoo/core/base/view-models/base_view_model.dart';
import 'package:tattoo/domain/usecases/auth/implementations/auth_usecase.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../core/base/models/base_success.dart';
import '../../../../core/router/core/router_service.dart';
import '../../../../domain/models/auth/user_model.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';

class MoreViewModel extends BaseViewModel {
  Future<void> signInUpOut(bool mounted) async {
    SignState signState = context.read<SignBloc>().state;

    if (signState is SignedIn) {
      BlocProvider.of<SignBloc>(context).add(const SigningOutEvent());

      AuthUseCase authUseCase = AuthUseCase();
      BaseResponse<UserModel> baseResponse = await authUseCase.signOut();

      if (baseResponse is BaseSuccess<UserModel>) {
        if (mounted) {
          BlocProvider.of<SignBloc>(context)
              .add(SignOutEvent(signOutUserModel: baseResponse.data!));
        }
      }
    } else {
      RouterService.instance.pushNamed(path: RouterConstants.signUpIn);
    }
  }
}
