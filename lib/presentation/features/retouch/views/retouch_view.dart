import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tattoo/core/base/views/base_view.dart';
import 'package:tattoo/core/extensions/context_extension.dart';
import 'package:tattoo/core/extensions/int_extension.dart';
import 'package:tattoo/core/extensions/string_extension.dart';
import 'package:tattoo/core/extensions/widget_extension.dart';
import 'package:tattoo/presentation/features/retouch/components/animated_retouching.dart';
import 'package:tattoo/presentation/features/retouch/components/retouch_ready.dart';
import 'package:tattoo/presentation/features/retouch/view-models/retouch_view_model.dart';
import 'package:tattoo/utils/logic/state/cubit/retouch/retouch_cubit.dart';

import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../components/retouch_background.dart';

class RetouchView extends View<RetouchViewModel> {
  final String? imageLink;

  RetouchView({required this.imageLink, super.key})
      : super(viewModelBuilder: () => RetouchViewModel());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RetouchCubit(),
      child: WillPopScope(
        onWillPop: viewModel.onBackPressed,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: buildAppBar(),
          body: Stack(
            children: [
              RetouchBackground(
                image: imageLink,
              ),
              BlocBuilder<RetouchCubit, RetouchState>(
                builder: (context, state) {
                  return SafeArea(
                    child: Padding(
                      padding: context.paddingLow,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildTitle(state),
                          viewModel.widget.dynamicVerticalSpace(context, 0.1),
                          state.isReady
                              ? const RetouchReady()
                              : const AnimatedRetouching(),
                          viewModel.widget.verticalSpace(75),
                          buildLoadingArea(state),
                          viewModel.widget.verticalSpace(10),
                          buildLoadingDescriptionArea(),
                          viewModel.widget.dynamicVerticalSpace(context, 0.05),
                          state.isReady ? buildShowResult() : buildTimeArea(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      leading: CloseButton(
        onPressed: () async {
          await viewModel.onBackPressed();
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

  Widget buildTitle(RetouchState state) {
    return Text(
      state.isReady
          ? LocaleKeys.retouchEnded.tr()
          : state.inRetouch
              ? LocaleKeys.retouchingPhoto.tr()
              : state.inQueue
                  ? LocaleKeys.outOfWorkTimeDescription.tr()
                  : "",
      style: TextStyle(
        fontSize: state.inQueue ? 18 : 22,
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
        buildLoadingDescription(LocaleKeys.control.tr()),
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

  Widget buildLoadingArea(RetouchState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: buildLoading(left: true, isDone: state is RetouchInQueue),
        ),
        Expanded(
          child: buildLoading(isDone: state is RetouchInControl),
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

  Widget buildShowResult() {
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
      onPressed: () {},
      child: Text(
        LocaleKeys.showResult.tr(),
      ),
    );
  }

  Widget buildTimeArea() {
    int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 600;

    return CountdownTimer(
      endTime: endTime,
      widgetBuilder: (context, time) {
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: LocaleKeys.approximateTimeLeft.tr(),
              ),
              TextSpan(
                text:
                    "    ${time?.hours.toFixed(2).concatIfNotEmpty(":")}${time?.min.toFixed(2).concatIfNotEmpty(":")}${time?.sec.toFixed(2)}",
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
