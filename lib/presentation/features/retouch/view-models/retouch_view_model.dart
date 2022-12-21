import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tattoo/core/base/view-models/base_view_model.dart';
import 'package:tattoo/domain/models/design-request/design_request_model.dart';
import 'package:tattoo/utils/logic/state/cubit/retouch/retouch_cubit.dart';

import '../../../../core/router/core/router_service.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/logic/state/cubit/home-tab/home_tab_cubit.dart';

class RetouchViewModel extends BaseViewModel {
  int endTime = DateTime.now().millisecondsSinceEpoch;
  final Duration oneDesignDuration = const Duration(minutes: 5);

  Future<bool> onBackPressed() async {
    BlocProvider.of<HomeTabCubit>(context).changeTab(2);

    RouterService.instance.popUntil(
      removeUntilPageName: RouterConstants.home,
    );

    return true;
  }

  void computeEndTime(RetouchState state) {
    List<DesignRequestModel>? designRequestModels;

    if (state is RetouchInRetouch) {
      designRequestModels = state.inRetouchDesignRequestModels;
    } else if (state is RetouchInQueue) {
      designRequestModels = state.inQueueDesignRequestModels;
    }

    if (designRequestModels == null) {
      return;
    }

    if (designRequestModels[0].startDesignDate != null) {
      Duration difference =
          DateTime.now().difference(designRequestModels[0].startDesignDate!);

      if (difference.inMinutes <= oneDesignDuration.inMinutes) {
        endTime = DateTime.now().millisecondsSinceEpoch +
            (designRequestModels.length - 2) *
                oneDesignDuration.inMilliseconds +
            (oneDesignDuration.inMilliseconds - difference.inMilliseconds);
      } else {
        endTime = DateTime.now().millisecondsSinceEpoch +
            (designRequestModels.length - 1) * oneDesignDuration.inMilliseconds;
      }
    } else {
      endTime = DateTime.now().millisecondsSinceEpoch +
          (designRequestModels.length - 1) * oneDesignDuration.inMilliseconds;
    }
  }
}
