import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../core/base/models/base_success.dart';
import '../../../../core/base/view-models/base_view_model.dart';
import '../../../../domain/models/auth/user_model.dart';
import '../../../../domain/repositories/auth/implementations/auth_repository.dart';
import '../../../../domain/repositories/auth/implementations/auto_auth_repository.dart';
import '../../../../domain/repositories/auth/implementations/email_auth_repository.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/logic/errors/auth/user_not_found_error.dart';
import '../../../../utils/logic/services/fcm/fcm_service.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';
import '../../../../utils/logic/state/cubit/settings/settings_cubit.dart';

class MyAppViewModel extends BaseViewModel {
  AutoAuthRepository autoAuthRepository = AutoAuthRepository();
  AuthRepository authRepository = AuthRepository();
  EmailAuthRepository emailAuthRepository = EmailAuthRepository();
  StreamSubscription? settingsStream;

  void initAndRemoveSplashScreen(BuildContext context) async {
    // Wait for settings initialize
    settingsStream = context.read<SettingsCubit>().stream.listen((event) async {
      settingsStream?.cancel();
      if (event.settingsModel?.id != null) {
        SignBloc signBloc = BlocProvider.of<SignBloc>(context);
        if (signBloc.state is SignIn) {
          if (emailAuthRepository.emailVerified()) {
            await onSignedInWithEmail(context);
          } else {
            await onNotSignedInWithEmail(context);
          }
        }
      }
    });

    // Start FCM Service
    await FCMService.instance.registerNotification();
  }

  Future<void> onNotSignedInWithEmail(BuildContext context) async {
    SignBloc signBloc = BlocProvider.of<SignBloc>(context);
    UserModel userModel = signBloc.state.userModel;

    if (userModel.id != null && userModel.id!.isNotEmpty) {
      BaseResponse baseResponse = await autoAuthRepository
          .updateLastAppEntryDate(UserModel(id: userModel.id));

      if (baseResponse is BaseSuccess) {
        await onUpdatedLastAppEntryDate(userModel, signBloc);
      } else if (baseResponse is UserNotFoundError) {
        await createUser(signBloc);
      }
    } else {
      await createUser(signBloc);
    }
  }

  Future<void> onUpdatedLastAppEntryDate(
      UserModel userModel, SignBloc signBloc) async {
    BaseResponse<UserModel> userBaseResponse =
        await autoAuthRepository.getUserWithId(userModel.id!);
    if (userBaseResponse is BaseSuccess<UserModel>) {
      signBloc.add(
          RestoreSignInEvent(restoreSignInUserModel: userBaseResponse.data!));
      FlutterNativeSplash.remove();
    }
  }

  Future<void> createUser(SignBloc signBloc) async {
    BaseResponse<UserModel> baseResponse =
        await autoAuthRepository.createUser();

    if (baseResponse is BaseSuccess<UserModel>) {
      signBloc
          .add(RestoreSignInEvent(restoreSignInUserModel: baseResponse.data!));
      FlutterNativeSplash.remove();
    }
  }

  Future<void> onSignedInWithEmail(BuildContext context) async {
    SignBloc signBloc = BlocProvider.of<SignBloc>(context);
    BaseResponse<UserModel> userResponse = authRepository.getCurrentUser();

    if (userResponse is BaseSuccess<UserModel>) {
      BaseResponse baseResponse = await autoAuthRepository
          .updateLastAppEntryDate(UserModel(id: userResponse.data?.id));

      if (baseResponse is BaseSuccess) {
        signBloc.add(const ChangeSignInStatusEvent());
        FlutterNativeSplash.remove();
      }
    }
  }

  String getInitialRoute() {
    return RouterConstants.home;
  }
}
