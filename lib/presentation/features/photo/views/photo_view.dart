import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../core/base/models/base_success.dart';
import '../../../../core/cache/shared_preferences_manager.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/widget_extension.dart';
import '../../../../core/router/core/router_service.dart';
import '../../../../domain/models/auth/user_model.dart';
import '../../../../domain/models/design-response/design_response_model.dart';
import '../../../../domain/repositories/design-responses/implementations/design_responses_repository.dart';
import '../../../../utils/logic/constants/cache/shared_preferences_constants.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/state/bloc/retouch-alert/retouch_alert_bloc.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';
import '../../../../utils/logic/state/cubit/home-tab/home_tab_cubit.dart';
import '../../../../utils/logic/state/cubit/photo/photo_cubit.dart';
import '../../../../utils/logic/state/cubit/ready/ready_cubit.dart';
import '../../../../utils/ui/constants/colors/app_colors.dart';
import '../components/evaluate_designer_alert.dart';
import '../components/retouch_alert.dart';

class PhotoView extends StatefulWidget {
  final DesignResponseModel designModel;

  const PhotoView({required this.designModel, Key? key}) : super(key: key);

  @override
  State<PhotoView> createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  @override
  void initState() {
    bool close =
        !(context.read<SignBloc>().state.userModel.isBoughtFirstDesign ??
            false);

    Future.delayed(const Duration(seconds: 3)).then((value) async {
      if (close) {
        await SharedPreferencesManager.instance.preferences?.setBool(
          SharedPreferencesConstants.isLookedFirstDesign,
          true,
        );

        if (mounted) {
          UserModel userModel = context.read<SignBloc>().state.userModel;

          bool isBoughtFirstDesign = (userModel.isBoughtFirstDesign ?? false);
          bool isLookedFirstDesign =
              SharedPreferencesManager.instance.preferences?.getBool(
                    SharedPreferencesConstants.isLookedFirstDesign,
                  ) ??
                  false;

          if (!isBoughtFirstDesign && isLookedFirstDesign) {
            context.read<HomeTabCubit>().changeTab(2);
            RouterService.instance.pop();

            /*RouterService.instance.pushNamed(
              path: RouterConstants.credits,
              data: CreditsViewType.insufficient,
            );*/
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildPhotoArena(),
              ],
            ),
          ),
          buildButtonsArena(),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: const CloseButton(),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.before.tr(),
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          Switch(
            value: context.watch<PhotoCubit>().state.isSwitch,
            inactiveTrackColor: Colors.grey,
            activeColor: Colors.grey,
            onChanged: (bool value) {
              BlocProvider.of<PhotoCubit>(context).changePhoto();
            },
          ),
          Text(
            LocaleKeys.after.tr(),
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  Widget buildPhotoArena() {
    int oldImageIndex = widget
            .designModel.designRequestModel?.designRequestImageModels2
            ?.indexWhere((element) => element.name == "1") ??
        0;
    oldImageIndex = oldImageIndex >= 0 ? oldImageIndex : 0;

    return GestureDetector(
      child: CachedNetworkImage(
        placeholder: (context, url) {
          return Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(
                HexColor("#666666"),
              ),
            ),
          );
        },
        imageUrl: context.watch<PhotoCubit>().state.isSwitch
            ? widget.designModel.imageLink ?? ""
            : widget.designModel.designRequestModel
                    ?.designRequestImageModels2![oldImageIndex].link ??
                "",
        fit: BoxFit.cover,
        width: context.dynamicWidth(1),
        height: context.dynamicHeight(0.6),
      ),
      onTapDown: (details) {
        BlocProvider.of<PhotoCubit>(context).showOldPhoto();
      },
      onTapUp: (details) {
        BlocProvider.of<PhotoCubit>(context).showNewPhoto();
      },
      onTapCancel: () {
        BlocProvider.of<PhotoCubit>(context).showNewPhoto();
      },
    );
  }

  Widget buildButtonsArena() {
    return Container(
      padding: EdgeInsets.only(bottom: context.lowValue),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Ink(
                width: context.dynamicWidth(0.35),
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.tertiary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: buildButton(
                  LocaleKeys.evaluateDesigner.tr(),
                  FontAwesomeIcons.faceSmile,
                  evaluateDesigner,
                ),
              ),
              Ink(
                height: 80,
                width: context.dynamicWidth(0.35),
                decoration: BoxDecoration(
                  color: AppColors.tertiary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: buildButton(
                  LocaleKeys.retouch.tr(),
                  FontAwesomeIcons.rotate,
                  retouch,
                ),
              ),
            ],
          ),
          widget.verticalSpace(30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: buildButton(
                    LocaleKeys.save.tr(), Icons.file_download_outlined, save),
              ),
              Expanded(
                child: buildButton(
                    LocaleKeys.share.tr(), Icons.share_outlined, share),
              ),
              Expanded(
                child: buildButton(LocaleKeys.delete.tr(),
                    Icons.delete_outline_rounded, delete),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildButton(String text, IconData iconData, Function() onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              iconData,
              size: 20,
            ),
            widget.verticalSpace(5),
            Text(
              text,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void evaluateDesigner() async {
    DesignResponseRepository designResponseRepository =
        DesignResponseRepository();
    BaseResponse<DesignResponseModel> baseResponse =
        await designResponseRepository
            .getDesignResponse(widget.designModel.requestId ?? "");

    if (baseResponse is BaseSuccess<DesignResponseModel> &&
        baseResponse.data != null &&
        baseResponse.data?.rating == null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return EvaluateDesignerAlert(
            designModel: baseResponse.data!,
          );
        },
      );
    }
  }

  void retouch() async {
    DesignResponseRepository designResponseRepository =
        DesignResponseRepository();
    BaseResponse<DesignResponseModel> baseResponse =
        await designResponseRepository
            .getDesignResponse(widget.designModel.requestId ?? "");

    if (baseResponse is BaseSuccess<DesignResponseModel> &&
        baseResponse.data != null &&
        baseResponse.data?.designRequestModel?.retouchId == null &&
        baseResponse.data?.designRequestModel?.previousRequestId == null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return BlocProvider<RetouchAlertBloc>(
            create: (_) => RetouchAlertBloc(),
            child: RetouchAlert(
              designModel: baseResponse.data!,
            ),
          );
        },
      );
    }
  }

  Future<void> share() async {
    await Share.share(widget.designModel.imageLink ?? "");
  }

  Future<void> save() async {
    String path = widget.designModel.imageLink ?? "";
    bool? success = await GallerySaver.saveImage("$path.png");
  }

  Future<void> delete() async {
    if (widget.designModel.id != null) {
      DesignResponseRepository designResponseRepository =
          DesignResponseRepository();
      await designResponseRepository.deleteDesign(widget.designModel.id!);

      if (mounted) {
        BlocProvider.of<ReadyCubit>(context).rebuild();
      }
      RouterService.instance.pop();
    }
  }
}
