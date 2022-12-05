import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:tattoo/core/base/views/base_view.dart';
import 'package:tattoo/presentation/features/tattoo-choose/view-models/tattoo_choose_view_model.dart';
import 'package:tattoo/utils/logic/helpers/gallery/editor_helper.dart';
import 'package:tattoo/utils/logic/state/bloc/sign/sign_bloc.dart';
import 'package:tattoo/utils/ui/constants/colors/app_colors.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/widget_extension.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/helpers/gallery/gallery_helper.dart';
import '../../../widgets/resizeable_widget.dart';

class TattooChooseView extends View<TattooChooseViewModel> {
  final XFile imageFile;

  TattooChooseView({super.key, required this.imageFile})
      : super(
            viewModelBuilder: () =>
                TattooChooseViewModel(imageFile: imageFile));

  Offset position = const Offset(0, 0);
  double prevScale = 1;
  double scale = 1;

  double width = 0;
  double height = 0;

  void updatePosition(Offset newPosition) {
    position += newPosition;
    viewModel.buildView();
  }

  void updateScale(double zoom) {
    scale = prevScale * zoom;
    viewModel.buildView();
  }

  void commitScale() {
    prevScale = scale;
    viewModel.buildView();
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
            viewModel.widget.verticalSpace(50),
            buildInfoArea(),
            Screenshot(
              controller: viewModel.screenshotController,
              child: buildEditArea(),
            ),
            viewModel.widget.verticalSpace(20),
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
            width: viewModel.context.dynamicWidth(1),
            height: viewModel.context.dynamicHeight(0.6),
            fit: BoxFit.cover,
            File(
              imageFile.path,
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
          Size(viewModel.context.dynamicWidth(0.9), 30),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
      ),
      onPressed: viewModel.onTapSend,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.sendToDesigner.tr(),
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          viewModel.widget.horizontalSpace(10),
          const Icon(Icons.arrow_forward),
        ],
      ),
    );
  }

  Widget buildAddTattoo() {
    return ElevatedButton.icon(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all<Size>(
          Size(viewModel.context.dynamicWidth(0.8), 50),
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
          var size = await GalleryHelper.instance.computeSize(
              viewModel.context, File(viewModel.frontImageFile!.path));
          width = size[0];
          height = size[1];
        }
        viewModel.buildView();
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
        left: viewModel.context.lowValue,
        right: viewModel.context.lowValue,
        top: viewModel.context.lowValue / 1.5,
        bottom: viewModel.context.lowValue / 1.5,
      ),
      color: AppColors.tertiary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          viewModel.widget.horizontalSpace(10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text(
                  "${}:",
                  textAlign: TextAlign.center,
                ),
                viewModel.widget.horizontalSpace(10),
                Text(
                  "${viewModel.context.watch<SignBloc>().state.userModel.balance}",
                  textAlign: TextAlign.center,
                ),
                viewModel.widget.horizontalSpace(5),
                const Icon(
                  Icons.stars_rounded,
                  color: Colors.green,
                ),
              ],
            ),
          ),
          viewModel.widget.horizontalSpace(10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text(
                  "${}:",
                  textAlign: TextAlign.center,
                ),
                viewModel.widget.horizontalSpace(10),
                const Text(
                  "${30}",
                  textAlign: TextAlign.center,
                ),
                viewModel.widget.horizontalSpace(5),
                const Icon(
                  Icons.stars_rounded,
                  color: Colors.green,
                ),
              ],
            ),
          ),
          viewModel.widget.horizontalSpace(10),
        ],
      ),
    );
  }

  Future<File> crop() async {
    String? editedImagePath = await EditorHelper.instance
        .getEditedImagePath(viewModel.context, viewModel.frontImageFile?.path);

    if (editedImagePath != null) {
      viewModel.frontImageFile = XFile(editedImagePath);
      viewModel.buildView();
    }

    return File(viewModel.frontImageFile!.path);
  }

  void close() {
    viewModel.frontImageFile = null;
    viewModel.buildView();
  }
}
