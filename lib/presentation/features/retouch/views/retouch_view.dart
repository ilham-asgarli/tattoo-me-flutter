import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tattoo/core/extensions/context_extension.dart';
import 'package:tattoo/core/extensions/int_extension.dart';
import 'package:tattoo/core/extensions/string_extension.dart';
import 'package:tattoo/core/extensions/widget_extension.dart';
import 'package:tattoo/presentation/features/retouch/components/animated_retouching.dart';
import 'package:tattoo/presentation/features/retouch/components/retouch_ready.dart';
import 'package:tattoo/presentation/features/retouch/view-models/retouch_view_model.dart';
import 'package:tattoo/utils/logic/state/cubit/retouch/retouch_cubit.dart';

import '../../../../core/router/core/router_service.dart';
import '../../../../domain/models/design-request/design_request_model.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../components/retouch_background.dart';

class RetouchView extends StatelessWidget {
  final List list;
  late final DesignRequestModel? designRequestModel;
  late final Function() rebuild;
  final RetouchViewModel viewModel = RetouchViewModel();

  RetouchView({required this.list, Key? key}) : super(key: key) {
    designRequestModel = list[0];
    rebuild = list[1];
  }

  @override
  Widget build(BuildContext context) {
    int imageIndex = designRequestModel?.designRequestImageModels2
            ?.indexWhere((element) => element.name == "1") ??
        0;
    imageIndex = imageIndex >= 0 ? imageIndex : 0;

    return BlocBuilder<RetouchCubit, RetouchState>(
      builder: (context, state) {
        viewModel.computeEndTime(context, state);

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
                ),
                buildBody(context),
              ],
            ),
          ),
        );
      },
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
            context.watch<RetouchCubit>().state is RetouchIsReady
                ? const RetouchReady()
                : const AnimatedRetouching(),
            context.widget.verticalSpace(75),
            buildLoadingArea(context),
            context.widget.verticalSpace(10),
            buildLoadingDescriptionArea(),
            context.widget.dynamicVerticalSpace(context, 0.05),
            context.watch<RetouchCubit>().state is RetouchIsReady
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
      state is RetouchIsReady
          ? LocaleKeys.retouchEnded.tr()
          : state is RetouchInRetouch
              ? LocaleKeys.retouchingPhoto.tr()
              : state is RetouchInQueue
                  ? LocaleKeys.outOfWorkTimeDescription.tr()
                  : "",
      style: TextStyle(
        fontSize: state is RetouchInQueue ? 18 : 22,
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
            data: [
              state.designResponseModel,
              rebuild,
            ],
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
