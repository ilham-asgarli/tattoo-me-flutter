import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tattoo/core/extensions/context_extension.dart';
import 'package:tattoo/core/extensions/widget_extension.dart';

import '../../../../core/router/core/router_service.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../../../../utils/logic/helpers/gallery/gallery_helper.dart';
import '../../../../utils/ui/constants/colors/app_colors.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(),
        body: SizedBox(
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
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        LocaleKeys.appName.tr(),
      ),
      centerTitle: true,
    );
  }

  Widget buildAddPhoto(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () async {
          XFile? imageFile = await GalleryHelper.instance.getFromGallery();
          if (imageFile != null) {
            RouterService.instance.pushNamed(
              path: RouterConstants.tattooChoose,
              data: XFile(imageFile.path),
            );
          }
        },
        child: Container(
          width: context.dynamicWidth(0.45),
          height: context.dynamicWidth(0.45),
          decoration: BoxDecoration(
            color: AppColors.tertiary,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
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
