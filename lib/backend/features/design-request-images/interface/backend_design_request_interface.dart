import 'package:tattoo/domain/models/design-request/design_request_image_model.dart';

import '../../../../core/base/models/base_response.dart';

abstract class BackendDesignRequestImageInterface {
  Future<BaseResponse<DesignRequestImageModel>> createDesignRequestImage(
    DesignRequestImageModel model,
  );

  Future<BaseResponse> updateDesignRequestImage(
    DesignRequestImageModel model,
  );
}
