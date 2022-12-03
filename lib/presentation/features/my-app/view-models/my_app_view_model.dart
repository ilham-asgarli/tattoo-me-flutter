import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:tattoo/core/base/models/base_response.dart';
import 'package:tattoo/domain/models/auth/user_model.dart';
import 'package:tattoo/domain/repositories/auth/implementations/auth_repository.dart';
import 'package:tattoo/domain/repositories/auth/implementations/auto_auth_repository.dart';
import 'package:tattoo/domain/usecases/auth/implementations/auth_usecase.dart';

import '../../../../core/base/models/base_success.dart';
import '../../../../core/base/view-models/base_view_model.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';

class MyAppViewModel extends BaseViewModel {
  MyAppViewModel({required super.context});

  AutoAuthRepository autoAuthRepository = AutoAuthRepository();
  AuthRepository authRepository = AuthRepository();
  AuthUseCase authUseCase = AuthUseCase();

  void initAndRemoveSplashScreen() async {
    SignBloc signBloc = BlocProvider.of<SignBloc>(context);
    if (authUseCase.isSignedIn() && signBloc.state is SignIn) {
      BlocProvider.of<SignBloc>(context).add(const ChangeSignInStatusEvent());
      FlutterNativeSplash.remove();

      BaseResponse<UserModel> userResponse = authRepository.getCurrentUser();

      if (userResponse is BaseSuccess<UserModel>) {
        BaseResponse baseResponse = await autoAuthRepository
            .updateLastAppEntryDate(UserModel(id: userResponse.data?.id));

        if (baseResponse is BaseSuccess) {
          FlutterNativeSplash.remove();
        }
      }
    } else {
      UserModel userModel = signBloc.state.userModel;

      if (userModel.id != null && userModel.id!.isNotEmpty) {
        BaseResponse baseResponse = await autoAuthRepository
            .updateLastAppEntryDate(UserModel(id: userModel.id));

        if (baseResponse is BaseSuccess) {
          FlutterNativeSplash.remove();
        }
      } else {
        BaseResponse<UserModel> baseResponse =
            await autoAuthRepository.createUser(UserModel());
        if (baseResponse is BaseSuccess<UserModel>) {
          signBloc.add(
              RestoreSignInEvent(restoreSignInUserModel: baseResponse.data!));
          FlutterNativeSplash.remove();
        }
      }
    }
  }

  String getInitialRoute() {
    return RouterConstants.home;
  }
}
