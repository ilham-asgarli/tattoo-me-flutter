import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/view-models/base_view_model.dart';
import '../../../../core/cache/shared_preferences_manager.dart';
import '../../../../core/router/core/router_service.dart';
import '../../../../domain/models/auth/user_model.dart';
import '../../../../domain/models/design-request/design_request_model.dart';
import '../../../../domain/models/design-response/design_response_model.dart';
import '../../../../domain/repositories/design-responses/implementations/get_design_response_repository.dart';
import '../../../../utils/logic/constants/cache/shared_preferences_constants.dart';
import '../../../../utils/logic/constants/enums/app_enums.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';

class ReadyViewModel extends BaseViewModel {
  GetDesignResponseRepository getDesignResponseRepository =
      GetDesignResponseRepository();

  Future<void> onTapImage(
    BuildContext context,
    DesignRequestModel? designRequestModel,
    List<DesignResponseModel> designModels,
    int index,
  ) async {
    UserModel userModel = context.read<SignBloc>().state.userModel;

    bool isBoughtFirstDesign = (userModel.isBoughtFirstDesign ?? false);
    bool isLookedFirstDesign =
        SharedPreferencesManager.instance.preferences?.getBool(
              SharedPreferencesConstants.isLookedFirstDesign,
            ) ??
            false;

    if (!isBoughtFirstDesign && isLookedFirstDesign) {
      RouterService.instance.pushNamed(
        path: RouterConstants.credits,
        data: CreditsViewType.insufficient,
      );
    } else if (designRequestModel?.finished ?? false) {
      RouterService.instance.pushNamed(
        path: RouterConstants.photo,
        data: designModels[index],
      );
    } else {
      RouterService.instance.pushNamed(
        path: RouterConstants.retouch,
        data: designModels[index].designRequestModel,
      );
    }
  }
}
