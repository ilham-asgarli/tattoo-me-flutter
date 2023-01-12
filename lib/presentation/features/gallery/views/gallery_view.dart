import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tattoo/core/extensions/context_extension.dart';
import 'package:tattoo/core/extensions/string_extension.dart';
import 'package:tattoo/core/extensions/widget_extension.dart';
import 'package:tattoo/utils/logic/constants/enums/app_enum.dart';

import '../../../../core/router/core/router_service.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/logic/helpers/gallery/gallery_helper.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: buildAppBar(),
        body: Container(
          padding: context.paddingNormal,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                HexColor("#262626"),
                HexColor("#666666"),
                Colors.grey,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              context.widget.verticalSpace(AppBar().preferredSize.height + 50),
              Text(
                LocaleKeys.galleryDescription.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              context.widget.verticalSpace(50),
              buildAddPhotoArea(context),
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
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        LocaleKeys.appName.tr(),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            RouterService.instance.pushNamed(
              path: RouterConstants.more,
            );
          },
          icon: const Icon(
            Icons.more_horiz_rounded,
            size: 30,
          ),
        ),
      ],
    );
  }

  Widget buildAddPhotoArea(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildChooseArea(context, GalleryChoose.camera),
        buildChooseArea(context, GalleryChoose.gallery),
      ],
    );
  }

  Widget buildChooseArea(
    BuildContext context,
    GalleryChoose galleryChoose,
  ) {
    return InkWell(
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
      onTap: () async {
        XFile? imageFile;
        if (galleryChoose == GalleryChoose.camera) {
          imageFile = await GalleryHelper.instance.getFromCamera();
        } else if (galleryChoose == GalleryChoose.gallery) {
          imageFile = await GalleryHelper.instance.getFromGallery();
        }

        if (imageFile != null) {
          RouterService.instance.pushNamed(
            path: RouterConstants.tattooChoose,
            data: XFile(imageFile.path),
          );
        }
      },
      child: Container(
        width: 100,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          color: HexColor("#333333"),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageIcon(
                galleryChoose == GalleryChoose.camera
                    ? AssetImage("ic_camera".toPNG)
                    : AssetImage("ic_galery".toPNG),
              ),
              context.widget.verticalSpace(5),
              Text(
                galleryChoose == GalleryChoose.camera ? "Kamera" : "Galeri",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
