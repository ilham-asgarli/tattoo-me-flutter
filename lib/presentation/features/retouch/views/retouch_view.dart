import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tattoo/core/base/models/base_success.dart';
import 'package:tattoo/domain/repositories/settings/implementations/settings_repository.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/int_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/extensions/widget_extension.dart';
import '../../../../core/router/core/router_service.dart';
import '../../../../domain/models/design-request/design_request_model.dart';
import '../../../../domain/models/settings/settings_model.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/logic/state/cubit/retouch/retouch_cubit.dart';
import '../components/animated_retouching.dart';
import '../components/retouch_background.dart';
import '../components/retouch_ready.dart';
import '../view-models/retouch_view_model.dart';

class RetouchView extends StatelessWidget {
  late final DesignRequestModel? designRequestModel;
  final RetouchViewModel viewModel = RetouchViewModel();

  RetouchView({required this.designRequestModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int imageIndex = designRequestModel?.designRequestImageModels2
            ?.indexWhere((element) => element.name == "2") ??
        0;
    imageIndex = imageIndex >= 0 ? imageIndex : 0;

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
            StreamBuilder<BaseResponse<SettingsModel>>(
              stream: SettingsRepository().getDesignRequestsSettingsStream(),
              builder: (context, snapshot) {
                BaseResponse<SettingsModel>? baseResponse = snapshot.data;
                if (baseResponse is BaseSuccess<SettingsModel>) {
                  viewModel.settingsModel = baseResponse.data;

                  return FutureBuilder(
                    future: viewModel.computeEndTime(context),
                    builder: (context, snapshot) {
                      return buildBody(context);
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
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
                : buildTimeArea(context),
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

    return Text(
      state.runtimeType == RetouchIsReady
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: buildLoading(left: true, isDone: state is RetouchInQueue),
        ),
        Expanded(
          child: buildLoading(isDone: state is RetouchInRetouch),
        ),
        Expanded(
          child: buildLoading(right: true, isDone: state is RetouchIsReady),
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

  Widget buildTimeArea(BuildContext context) {
    return CountdownTimer(
      onEnd: () {
        BlocProvider.of<RetouchCubit>(context)
            .listenToDesignStatus(designRequestModel);
      },
      endTime: viewModel.endTime,
      widgetBuilder: (context, time) {
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: LocaleKeys.approximateTimeLeft.tr(),
              ),
              TextSpan(
                text:
                    "    ${time?.hours.toFixed(2).concatIfNotEmpty(":") ?? ""}${time?.min.toFixed(2, visibility: true).concatIfNotEmpty(":") ?? "00:"}${time?.sec.toFixed(2) ?? "00"}",
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
