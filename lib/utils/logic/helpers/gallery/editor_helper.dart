import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../ui/constants/colors/app_colors.dart';
import '../../constants/locale/locale_keys.g.dart';

class EditorHelper {
  static final EditorHelper instance = EditorHelper._init();

  EditorHelper._init();

  Future<String?> getEditedImagePath(BuildContext context, String? path) async {
    if (path == null) {
      return null;
    }

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      compressFormat: ImageCompressFormat.png,
      compressQuality: 100,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: LocaleKeys.imageEditorTitle.tr(),
          toolbarColor: AppColors.mainColor,
          toolbarWidgetColor: AppColors.secondColor,
          statusBarColor: AppColors.mainColor,
          backgroundColor: AppColors.mainColor,
          cropFrameColor: Colors.transparent,
          activeControlsWidgetColor: Colors.deepOrangeAccent,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: LocaleKeys.imageEditorTitle.tr(),
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    return croppedFile?.path;
  }
}
