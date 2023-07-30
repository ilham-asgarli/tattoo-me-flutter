import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntp/ntp.dart';

import '../../../../backend/utils/constants/app/app_constants.dart';
import '../../../../core/base/view-models/base_view_model.dart';
import '../../../../core/extensions/int_extension.dart';
import '../../../../core/router/core/router_service.dart';
import '../../../../domain/models/design-request/design_request_model.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/logic/state/cubit/home-tab/home_tab_cubit.dart';
import '../../../../utils/logic/state/cubit/retouch/retouch_cubit.dart';

class RetouchViewModel extends BaseViewModel {
  int endTime = DateTime.now().millisecondsSinceEpoch;

  Future<bool> onBackPressed(BuildContext context) async {
    BlocProvider.of<HomeTabCubit>(context).changeTab(2);

    RouterService.instance.popUntil(
      removeUntilPageName: RouterConstants.home,
    );

    return true;
  }

  Future computeEndTime(BuildContext context) async {
    RetouchState state = context.watch<RetouchCubit>().state;
    List<DesignRequestModel>? designRequestModels;
    DateTime now = await NTP.now();

    if (state is RetouchInRetouch) {
      designRequestModels = state.inRetouchDesignRequestModels;
    } else if (state is RetouchInQueue) {
      designRequestModels = state.inQueueDesignRequestModels;
    }

    if (designRequestModels == null) {
      return;
    }

    if (designRequestModels.last.startDesignDate != null) {
      Duration difference =
          now.difference(designRequestModels.last.startDesignDate!);

      if (difference.inMinutes <= AppConstants.oneDesignDuration.inMinutes) {
        endTime = now.millisecondsSinceEpoch +
            (AppConstants.oneDesignDuration.inMilliseconds -
                difference.inMilliseconds);
      } else {
        endTime = now.millisecondsSinceEpoch +
            AppConstants.oneDesignDuration.inMilliseconds;
      }
    } else {
      endTime = now.millisecondsSinceEpoch +
          (designRequestModels.length - 1).toZeroOrPositive() *
              AppConstants.oneDesignDuration.inMilliseconds;
    }

    if (endTime == now.millisecondsSinceEpoch) {
      endTime += AppConstants.oneDesignDuration.inMilliseconds;
    }

    return;
  }
}
