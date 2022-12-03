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
      await onSignedInWithEmail();
    } else {
      await onNotSignedInWithEmail();
    }
  }

  Future<void> onNotSignedInWithEmail() async {
    SignBloc signBloc = BlocProvider.of<SignBloc>(context);
    UserModel userModel = signBloc.state.userModel;

    if (userModel.id != null && userModel.id!.isNotEmpty) {
      await updateLastAppEntryDateAndRemoveSplashScreen(userModel.id);
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

  Future<void> onSignedInWithEmail() async {
    BlocProvider.of<SignBloc>(context).add(const ChangeSignInStatusEvent());

    BaseResponse<UserModel> userResponse = authRepository.getCurrentUser();

    if (userResponse is BaseSuccess<UserModel>) {
      await updateLastAppEntryDateAndRemoveSplashScreen(userResponse.data?.id);
    }
  }

  Future<void> updateLastAppEntryDateAndRemoveSplashScreen(String? id) async {
    BaseResponse baseResponse =
        await autoAuthRepository.updateLastAppEntryDate(UserModel(id: id));

    if (baseResponse is BaseSuccess) {
      FlutterNativeSplash.remove();
    }
  }

  String getInitialRoute() {
    return RouterConstants.home;
  }
}
