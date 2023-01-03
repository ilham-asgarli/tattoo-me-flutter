import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tattoo/domain/models/settings/settings_model.dart';

import '../../../../core/base/view-models/base_view_model.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/extensions/int_extension.dart';
import '../../../../core/router/core/router_service.dart';
import '../../../../domain/models/design-request/design_request_model.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/logic/state/cubit/home-tab/home_tab_cubit.dart';
import '../../../../utils/logic/state/cubit/retouch/retouch_cubit.dart';

class RetouchViewModel extends BaseViewModel {
  SettingsModel? settingsModel;
  int endTime = DateTime.now().millisecondsSinceEpoch;
  final Duration oneDesignDuration = const Duration(minutes: 5);

  Future<bool> onBackPressed(BuildContext context) async {
    BlocProvider.of<HomeTabCubit>(context).changeTab(2);

    RouterService.instance.popUntil(
      removeUntilPageName: RouterConstants.home,
    );

    return true;
  }

  void computeEndTime(BuildContext context) {
    RetouchState state = context.read<RetouchCubit>().state;
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
            (designRequestModels.length - 2).toZeroOrPositive() *
                oneDesignDuration.inMilliseconds +
            (oneDesignDuration.inMilliseconds - difference.inMilliseconds);
      } else {
        endTime = DateTime.now().millisecondsSinceEpoch +
            (designRequestModels.length - 1).toZeroOrPositive() *
                oneDesignDuration.inMilliseconds;
      }
    } else {
      endTime = DateTime.now().millisecondsSinceEpoch +
          (designRequestModels.length - 1).toZeroOrPositive() *
              oneDesignDuration.inMilliseconds;
    }

    addNotWorkTime(context, designRequestModels);

    if (endTime == DateTime.now().millisecondsSinceEpoch) {
      endTime += oneDesignDuration.inMilliseconds;
    }
  }

  void addNotWorkTime(
    BuildContext context,
    List<DesignRequestModel>? designRequestModels,
  ) {
    DateTime workStartDate = DateTime.now();

    if (DateTime.now().hour < settingsModel?.workHours?[0]) {
      workStartDate = DateTime.now().copyWith(
        hour: settingsModel?.workHours?[0],
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );
      BlocProvider.of<RetouchCubit>(context).inQueue(designRequestModels);
    } else if (DateTime.now().hour >= settingsModel?.workHours?[1]) {
      workStartDate = DateTime.now().copyWith(
        day: DateTime.now().day + 1,
        hour: settingsModel?.workHours?[0],
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );
      BlocProvider.of<RetouchCubit>(context).inQueue(designRequestModels);
    }

    endTime += workStartDate.difference(DateTime.now()).inMilliseconds;
  }
}
