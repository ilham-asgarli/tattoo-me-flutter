import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ntp/ntp.dart';
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
  final Duration oneDesignDuration = const Duration(minutes: 10);

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

      if (difference.inMinutes <= oneDesignDuration.inMinutes) {
        endTime = now.millisecondsSinceEpoch +
            (designRequestModels.length - 2).toZeroOrPositive() *
                oneDesignDuration.inMilliseconds +
            (oneDesignDuration.inMilliseconds - difference.inMilliseconds);
      } else {
        endTime = now.millisecondsSinceEpoch +
            (designRequestModels.length - 1).toZeroOrPositive() *
                oneDesignDuration.inMilliseconds;
      }
    } else {
      endTime = now.millisecondsSinceEpoch +
          (designRequestModels.length - 1).toZeroOrPositive() *
              oneDesignDuration.inMilliseconds;
    }

    addNotWorkTime(context, designRequestModels, now);

    if (endTime == now.millisecondsSinceEpoch) {
      endTime += oneDesignDuration.inMilliseconds;
    }

    return;
  }

  void addNotWorkTime(
    BuildContext context,
    List<DesignRequestModel>? designRequestModels,
    DateTime now,
  ) async {
    DateTime workStartDate = now;

    if (now.hour < settingsModel?.workHours?[0]) {
      workStartDate = now.copyWith(
        hour: settingsModel?.workHours?[0],
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );
      BlocProvider.of<RetouchCubit>(context).inQueue(designRequestModels);
    } else if (now.hour >= settingsModel?.workHours?[1]) {
      workStartDate = now.copyWith(
        day: now.day + 1,
        hour: settingsModel?.workHours?[0],
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );
      BlocProvider.of<RetouchCubit>(context).inQueue(designRequestModels);
    }
    /*else {
      return;
    }*/

    endTime += workStartDate.difference(now).inMilliseconds;
  }
}
