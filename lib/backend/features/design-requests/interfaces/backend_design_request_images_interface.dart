import 'package:tattoo/domain/models/design-request/design_request_image_model_2.dart';

import '../../../../core/base/models/base_response.dart';

abstract class BackendDesignRequestImagesInterface {
  Future<BaseResponse<DesignRequestImageModel2>> createDesignRequestImage(
    DesignRequestImageModel2 model,
  );

  Future<BaseResponse> updateDesignRequestImage(
    DesignRequestImageModel2 model,
  );
}
