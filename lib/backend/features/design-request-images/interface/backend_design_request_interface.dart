import 'package:tattoo/domain/models/design-request/design_response_image_model.dart';

import '../../../../core/base/models/base_response.dart';

abstract class BackendDesignRequestImageInterface {
  Future<BaseResponse<DesignResponseImageModel>> createDesignRequestImage(
    DesignResponseImageModel model,
  );

  Future<BaseResponse> updateDesignRequestImage(
    DesignResponseImageModel model,
  );
}
