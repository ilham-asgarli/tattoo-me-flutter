import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../backend/utils/constants/app/app_constants.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/widget_extension.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/helpers/gallery/editor_helper.dart';
import '../../../../utils/logic/helpers/gallery/gallery_helper.dart';
import '../../../../utils/logic/state/bloc/sign/sign_bloc.dart';
import '../../../../utils/ui/constants/colors/app_colors.dart';
import '../../../widgets/resizeable_widget.dart';
import '../view-models/tattoo_choose_view_model.dart';

class TattooChooseView extends StatefulWidget {
  final XFile imageFile;

  const TattooChooseView({required this.imageFile, Key? key}) : super(key: key);

  @override
  State<TattooChooseView> createState() => _TattooChooseViewState();
}

class _TattooChooseViewState extends State<TattooChooseView> {
  late final TattooChooseViewModel viewModel;
  Offset position = const Offset(0, 0);
  double prevScale = 1;
  double scale = 1;

  double width = 0;
  double height = 0;

  void updatePosition(Offset newPosition) {
    setState(() {
      position += newPosition;
    });
  }

  void updateScale(double zoom) {
    setState(() {
      scale = prevScale * zoom;
    });
  }

  void commitScale() {
    setState(() {
      prevScale = scale;
    });
  }

  @override
  void initState() {
    viewModel = TattooChooseViewModel(imageFile: widget.imageFile);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.appName.tr(),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: viewModel.frontImageFile != null,
              child: Text(
                LocaleKeys.tattooChooseDescription.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            widget.verticalSpace(50),
            buildInfoArea(),
            Screenshot(
              controller: viewModel.screenshotController,
              child: buildEditArea(),
            ),
            widget.verticalSpace(20),
            viewModel.frontImageFile == null ? buildAddTattoo() : buildSend(),
          ],
        ),
      ),
    );
  }

  Widget buildEditArea() {
    return GestureDetector(
      onScaleUpdate: (details) => updateScale(details.scale),
      onScaleEnd: (_) => commitScale(),
      child: Stack(
        children: [
          Image.file(
            width: context.dynamicWidth(1),
            height: context.dynamicHeight(0.6),
            fit: BoxFit.cover,
            File(
              widget.imageFile.path,
            ),
          ),
          Visibility(
            visible: viewModel.frontImageFile != null,
            child: Builder(builder: (context) {
              return Positioned(
                left: position.dx,
                top: position.dy,
                child: ResizeableWidget(
                  onCrop: crop,
                  onClose: close,
                  width: width,
                  height: height,
                  positionedContext: context,
                  builder: (double width, double height, double angle) {
                    return buildTattoo(width, height, angle);
                  },
                  onDragEnd: (offset) {
                    updatePosition(offset);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildSend() {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all<Size>(
          Size(context.dynamicWidth(0.9), 30),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
      ),
      onPressed: () {
        viewModel.onTapSend(context, mounted);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.sendToDesigner.tr(),
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          widget.horizontalSpace(10),
          const Icon(Icons.arrow_forward),
        ],
      ),
    );
  }

  Widget buildAddTattoo() {
    return ElevatedButton.icon(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all<Size>(
          Size(context.dynamicWidth(0.8), 50),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(AppColors.tertiary),
      ),
      icon: const Icon(
        Icons.add,
        color: Colors.white,
      ),
      onPressed: () async {
        viewModel.frontImageFile =
            await GalleryHelper.instance.getFromGallery();
        if (viewModel.frontImageFile != null) {
          var size = await GalleryHelper.instance
              .computeSize(context, File(viewModel.frontImageFile!.path));
          width = size[0];
          height = size[1];
        }
        setState(() {});
      },
      label: Text(
        LocaleKeys.addTattoo.tr(),
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildTattoo(double width, double height, double angle) {
    return viewModel.frontImageFile != null
        ? Transform.rotate(
            angle: angle,
            child: Image.file(
              width: width,
              height: height,
              fit: BoxFit.fill,
              File(
                viewModel.frontImageFile!.path,
              ),
            ),
          )
        : const SizedBox();
  }

  Widget buildInfoArea() {
    return Container(
      padding: EdgeInsets.only(
        left: context.lowValue,
        right: context.lowValue,
        top: context.lowValue / 1.5,
        bottom: context.lowValue / 1.5,
      ),
      color: AppColors.tertiary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.horizontalSpace(10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${LocaleKeys.designPrice.tr()}:",
                  textAlign: TextAlign.center,
                ),
                widget.horizontalSpace(10),
                Text(
                  AppConstants.tattooDesignPrice.toString(),
                  textAlign: TextAlign.center,
                ),
                widget.horizontalSpace(5),
                const Icon(
                  Icons.stars_rounded,
                  color: Colors.green,
                ),
              ],
            ),
          ),
          widget.horizontalSpace(10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${LocaleKeys.balance.tr()}:",
                  textAlign: TextAlign.center,
                ),
                widget.horizontalSpace(10),
                Text(
                  "${context.watch<SignBloc>().state.userModel.balance}",
                  textAlign: TextAlign.center,
                ),
                widget.horizontalSpace(5),
                const Icon(
                  Icons.stars_rounded,
                  color: Colors.green,
                ),
              ],
            ),
          ),
          widget.horizontalSpace(10),
        ],
      ),
    );
  }

  Future<File> crop() async {
    String? editedImagePath = await EditorHelper.instance
        .getEditedImagePath(context, viewModel.frontImageFile?.path);

    if (editedImagePath != null) {
      setState(() {
        viewModel.frontImageFile = XFile(editedImagePath);
      });
    }

    return File(viewModel.frontImageFile!.path);
  }

  void close() {
    setState(() {
      viewModel.frontImageFile = null;
    });
  }
}
