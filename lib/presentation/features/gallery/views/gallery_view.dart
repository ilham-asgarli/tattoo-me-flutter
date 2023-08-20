import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../core/base/models/base_success.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/num_extension.dart';
import '../../../../core/router/core/router_service.dart';
import '../../../../domain/repositories/design-requests/implementations/get_design_request_repository.dart';
import '../../../../utils/logic/constants/enums/app_enums.dart';
import '../../../../utils/logic/constants/locale/locale_keys.g.dart';
import '../../../../utils/logic/constants/router/router_constants.dart';
import '../components/add_photo.dart';
import '../components/designer_info.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Padding(
        padding: context.paddingNormal,
        child: Column(
          children: [
            10.verticalSpace,
            StreamBuilder(
              stream: GetDesignRequestRepository()
                  .backendGetDesignRequest
                  .getMinDesignerRequestCount(),
              builder: (context, snapshot) {
                int count = 0;

                if (snapshot.hasData) {
                  BaseResponse<int>? baseResponse = snapshot.data;
                  if (baseResponse is BaseSuccess<int>) {
                    count = baseResponse.data!;
                  }
                }

                return DesignerInfo(
                  count: count,
                );
              },
            ),
            65.verticalSpace,
            Text(
              LocaleKeys.galleryDescription.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
            const Spacer(flex: 2),
            const AddPhoto(galleryChoose: GalleryChoose.gallery),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
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
}
