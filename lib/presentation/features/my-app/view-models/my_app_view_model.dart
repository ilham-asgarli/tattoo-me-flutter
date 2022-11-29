import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:tattoo/core/base/models/base_response.dart';
import 'package:tattoo/core/base/models/base_success.dart';
import 'package:tattoo/domain/repositories/auth/implementations/anonymous_auth_repository.dart';
import 'package:tattoo/domain/usecases/auth/implementations/auth_usecase.dart';

import '../../../../core/base/view-models/base_view_model.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';

class MyAppViewModel extends BaseViewModel {
  MyAppViewModel({required super.context});

  void initAndRemoveSplashScreen() async {
    AuthUseCase authUseCase = AuthUseCase();

    if (!await authUseCase.isSignedIn()) {
      AnonymousAuthImplementation anonymousAuth = AnonymousAuthImplementation();
      BaseResponse responseModel = await anonymousAuth.signInAnonymously();

      if (responseModel is BaseSuccess) {
        FlutterNativeSplash.remove();
      }
    } else {
      FlutterNativeSplash.remove();
    }
  }

  String getInitialRoute() {
    return RouterConstants.home;
  }
}
