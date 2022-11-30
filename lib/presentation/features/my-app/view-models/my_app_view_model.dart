import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:tattoo/core/base/models/base_response.dart';
import 'package:tattoo/core/base/models/base_success.dart';
import 'package:tattoo/domain/repositories/auth/implementations/anonymous_auth_repository.dart';
import 'package:tattoo/domain/usecases/auth/implementations/auth_usecase.dart';

import '../../../../core/base/view-models/base_view_model.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';

class MyAppViewModel extends BaseViewModel {
  MyAppViewModel({required super.context});

  void initAndRemoveSplashScreen() async {
    AuthUseCase authUseCase = AuthUseCase();

    if (!await authUseCase.isSignedIn()) {
      AnonymousAuthRepository anonymousAuth = AnonymousAuthRepository();
      BaseResponse baseResponse = await anonymousAuth.signInAnonymously();

      if (baseResponse is BaseSuccess) {
        FlutterNativeSplash.remove();
      }
    } else {
      BlocProvider.of<SignBloc>(context).add(const ChangeSignInStatusEvent());
      FlutterNativeSplash.remove();
    }
  }

  String getInitialRoute() {
    return RouterConstants.home;
  }
}
