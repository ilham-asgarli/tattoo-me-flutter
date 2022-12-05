import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tattoo/core/extensions/context_extension.dart';
import 'package:tattoo/core/extensions/widget_extension.dart';
import 'package:tattoo/presentation/features/photo/components/evaluate_designer_alert.dart';
import 'package:tattoo/presentation/features/photo/components/retouch_alert.dart';
import 'package:tattoo/utils/logic/constants/locale/locale_keys.g.dart';
import 'package:tattoo/utils/ui/constants/colors/app_colors.dart';

import '../../../../domain/models/design-request/design_model.dart';

class PhotoView extends StatefulWidget {
  final DesignModel designModel;

  const PhotoView({required this.designModel, Key? key}) : super(key: key);

  @override
  State<PhotoView> createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  bool isNew = true;

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
            value: isNew,
            inactiveTrackColor: Colors.grey,
            activeColor: Colors.grey,
            onChanged: (bool value) {
              setState(() {
                isNew = !isNew;
              });
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
    int oldImageIndex = widget.designModel.designResponseImageModels
            ?.indexWhere((element) => element.name == "1") ??
        0;
    oldImageIndex = oldImageIndex >= 0 ? oldImageIndex : 0;

    return GestureDetector(
      child: Image.network(
        isNew
            ? ""
            : widget.designModel.designResponseImageModels![oldImageIndex]
                    .link ??
                "",
        fit: BoxFit.cover,
        width: context.dynamicWidth(1),
        height: context.dynamicHeight(0.6),
      ),
      onTapDown: (details) {
        setState(() {
          isNew = false;
        });
      },
      onTapUp: (details) {
        setState(() {
          isNew = true;
        });
      },
      onTapCancel: () {
        setState(() {
          isNew = true;
        });
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
              Container(
                width: context.dynamicWidth(0.35),
                height: 75,
                padding: context.paddingLow,
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
              Container(
                height: 75,
                width: context.dynamicWidth(0.35),
                padding: context.paddingLow,
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
              buildButton(
                  LocaleKeys.save.tr(), Icons.file_download_outlined, () {}),
              buildButton(LocaleKeys.share.tr(), Icons.share_outlined, () {}),
              buildButton(
                  LocaleKeys.delete.tr(), Icons.delete_outline_rounded, () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildButton(String text, IconData iconData, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
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
    );
  }

  void evaluateDesigner() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return EvaluateDesignerAlert();
      },
    );
  }

  void retouch() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const RetouchAlert();
      },
    );
  }
}
