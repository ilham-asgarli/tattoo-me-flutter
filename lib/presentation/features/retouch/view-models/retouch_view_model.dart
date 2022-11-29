import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tattoo/core/base/view-models/base_view_model.dart';

import '../../../../core/router/core/router_service.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/logic/state/cubit/home-tab/home_tab_cubit.dart';

class RetouchViewModel extends BaseViewModel {
  RetouchViewModel({required super.context});

  Future<bool> onBackPressed() async {
    BlocProvider.of<HomeTabCubit>(context).changeTab(2);

    RouterService.instance.popUntil(
      removeUntilPageName: RouterConstants.home,
    );

    return true;
  }
}
