import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tattoo/core/extensions/context_extension.dart';
import 'package:tattoo/core/extensions/string_extension.dart';
import 'package:tattoo/core/extensions/widget_extension.dart';
import 'package:tattoo/presentation/features/retouch/components/retouch_background.dart';

import '../../../../core/router/core/router_service.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/logic/helpers/gallery/gallery_helper.dart';
import '../../../../utils/ui/constants/colors/app_colors.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(),
      body: Stack(
        children: [
          RetouchBackground(
            image: "ic_bg_3".toJPG,
            sigmaX: 0,
            sigmaY: 0,
            backgroundColor: Colors.black.withOpacity(0.6),
          ),
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  top: 150,
                  left: 10,
                  right: 10,
                  child: Text(
                    LocaleKeys.galleryDescription.tr(),
                    textAlign: TextAlign.center,
                  ),
                ),
                buildAddPhoto(context),
              ],
            ),
          ),
        ],
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

  Widget buildAddPhoto(BuildContext context) {
    return Center(
      child: InkWell(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        onTap: () async {
          XFile? imageFile = await GalleryHelper.instance.getFromGallery();
          if (imageFile != null) {
            RouterService.instance.pushNamed(
              path: RouterConstants.tattooChoose,
              data: XFile(imageFile.path),
            );
          }
        },
        child: SizedBox(
          width: context.dynamicWidth(0.45),
          height: context.dynamicWidth(0.45),
          /*decoration: BoxDecoration(
            color: AppColors.tertiary,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),*/
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.plus,
                color: AppColors.secondColor,
                size: 30,
              ),
              context.widget.verticalSpace(15),
              Text(
                LocaleKeys.addPhoto.tr(),
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.secondColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
