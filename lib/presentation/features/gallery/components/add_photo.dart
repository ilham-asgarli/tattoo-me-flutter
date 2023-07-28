import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/num_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/router/core/router_service.dart';
import '../../../../utils/logic/constants/enums/app_enum.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/logic/helpers/gallery/gallery_helper.dart';
import '../../../components/progress_dialog.dart';

class AddPhoto extends StatelessWidget {
  final GalleryChoose galleryChoose;

  const AddPhoto({
    super.key,
    required this.galleryChoose,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
      onTap: () async {
        showProgressDialog(context);

        XFile? imageFile;
        if (galleryChoose == GalleryChoose.camera) {
          imageFile = await GalleryHelper.instance.getFromCamera();
        } else if (galleryChoose == GalleryChoose.gallery) {
          imageFile = await GalleryHelper.instance.getFromGallery();
        }

        RouterService.instance.pop();

        if (imageFile != null) {
          RouterService.instance.pushNamed(
            path: RouterConstants.tattooChoose,
            data: XFile(imageFile.path),
          );
        }
      },
      child: Padding(
        padding: context.paddingLow,
        child: Column(
          children: [
            ImageIcon(
              AssetImage("ic_aperture".toPNG),
              color: HexColor("#919191"),
              size: 55,
            ),
            10.verticalSpace,
            Text(
              LocaleKeys.addPhoto.tr().toTitleCase,
            ),
          ],
        ),
      ),
    );
  }

  void showProgressDialog(context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return const ProgressDialog();
      },
    );
  }
}
