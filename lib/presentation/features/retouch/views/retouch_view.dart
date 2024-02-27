import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../core/cache/shared_preferences_manager.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/widget_extension.dart';
import '../../../../core/router/core/router_service.dart';
import '../../../../domain/models/design-request/design_request_model.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/logic/state/bloc/designer-status/designer_status_bloc.dart';
import '../../../../utils/logic/state/cubit/retouch/retouch_cubit.dart';
import '../components/animated_retouching.dart';
import '../components/retouch_background.dart';
import '../components/retouch_ready.dart';
import '../components/retouch_timer.dart';
import '../view-models/retouch_view_model.dart';

class RetouchView extends StatelessWidget {
  late final DesignRequestModel? designRequestModel;
  final RetouchViewModel viewModel = RetouchViewModel();

  RetouchView({required this.designRequestModel, super.key}) {
    imageIndex = designRequestModel?.designRequestImageModels2
            ?.indexWhere((element) => element.name == "2") ??
        0;
    imageIndex = imageIndex >= 0 ? imageIndex : 0;

    firstLook = SharedPreferencesManager.instance.preferences
            ?.getBool(designRequestModel?.id ?? "") ??
        true;
    SharedPreferencesManager.instance.preferences
        ?.setBool(designRequestModel?.id ?? "", false);
  }

  late final bool firstLook;
  late int imageIndex;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return viewModel.onBackPressed(context);
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: buildAppBar(context),
        body: Stack(
          children: [
            RetouchBackground(
              image: designRequestModel
                  ?.designRequestImageModels2?[imageIndex].link,
              backgroundColor: Colors.black.withOpacity(0.3),
            ),
            buildBody(context),
          ],
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: context.paddingLow,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTitle(context),
            context.widget.dynamicVerticalSpace(context, 0.1),
            context.watch<RetouchCubit>().state.runtimeType == RetouchIsReady
                ? const RetouchReady()
                : const AnimatedRetouching(),
            context.widget.verticalSpace(75),
            buildLoadingArea(context),
            context.widget.verticalSpace(10),
            buildLoadingDescriptionArea(),
            context.widget.dynamicVerticalSpace(context, 0.05),
            context.watch<RetouchCubit>().state.runtimeType == RetouchIsReady
                ? buildShowResult(context)
                : context.watch<DesignerStatusBloc>().state is HasDesigner
                    ? const RetouchTimer()
                    : firstLook
                        ? ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(horizontal: 25),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green),
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              await viewModel.onBackPressed(context);
                            },
                            child: Text(
                              LocaleKeys.finished.tr(),
                            ),
                          )
                        : const SizedBox(),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      leading: CloseButton(
        onPressed: () async {
          await viewModel.onBackPressed(context);
        },
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        LocaleKeys.photo.tr(),
        style: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 17,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget buildTitle(BuildContext context) {
    RetouchState state = context.watch<RetouchCubit>().state;
    DesignerStatusState designerStatusState =
        context.watch<DesignerStatusBloc>().state;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        designerStatusState is NoActiveDesigner
            ? LocaleKeys.noDesignerDescription.tr()
            : state.runtimeType == RetouchIsReady
                ? LocaleKeys.retouchEnded.tr()
                : state.runtimeType == RetouchInRetouch
                    ? LocaleKeys.retouchingPhoto.tr()
                    : state.runtimeType == RetouchInQueue
                        ? LocaleKeys.queueDescription.tr()
                        : "",
        style: TextStyle(
          fontSize: state.runtimeType == RetouchInQueue ? 18 : 22,
          fontWeight: FontWeight.w300,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildLoadingDescriptionArea() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buildLoadingDescription(LocaleKeys.queue.tr()),
        buildLoadingDescription(LocaleKeys.retouching.tr()),
        buildLoadingDescription(LocaleKeys.ready.tr()),
      ],
    );
  }

  Widget buildLoadingDescription(String description) {
    return Text(
      description,
      style: const TextStyle(
        fontSize: 12,
      ),
    );
  }

  Widget buildLoadingArea(BuildContext context) {
    RetouchState state = context.watch<RetouchCubit>().state;
    DesignerStatusState designerStatusState =
        context.watch<DesignerStatusBloc>().state;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: buildLoading(
            left: true,
            isDone:
                state is RetouchInQueue && designerStatusState is HasDesigner,
          ),
        ),
        Expanded(
          child: buildLoading(
            isDone:
                state is RetouchInRetouch && designerStatusState is HasDesigner,
          ),
        ),
        Expanded(
          child: buildLoading(
            right: true,
            isDone:
                state is RetouchIsReady && designerStatusState is HasDesigner,
          ),
        ),
      ],
    );
  }

  Widget buildLoading({
    bool isDone = false,
    bool left = false,
    bool right = false,
  }) {
    return Container(
      height: 10,
      decoration: BoxDecoration(
        color: isDone ? Colors.green : HexColor("#a6a6a6"),
        borderRadius: BorderRadius.horizontal(
          left: left ? const Radius.circular(3) : Radius.zero,
          right: right ? const Radius.circular(3) : Radius.zero,
        ),
      ),
    );
  }

  Widget buildShowResult(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
        elevation: MaterialStateProperty.all(0),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
      onPressed: () {
        RetouchState state = context.read<RetouchCubit>().state;
        if (state is RetouchIsReady) {
          RouterService.instance.pushNamedAndRemoveUntil(
            path: RouterConstants.photo,
            removeUntilPageName: RouterConstants.home,
            data: state.designResponseModel,
          );
        }
      },
      child: Text(
        LocaleKeys.showResult.tr(),
      ),
    );
  }
}
