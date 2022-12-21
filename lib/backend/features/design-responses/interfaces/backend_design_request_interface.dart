import 'package:tattoo/domain/models/design-response/design_response_model.dart';

import '../../../../core/base/models/base_response.dart';

abstract class BackendDesignResponseInterface {
  Future<BaseResponse> updateDesignResponse(
      DesignResponseModel designResponseModel);

  Future<BaseResponse> deleteDesign(String designId);

  Future<BaseResponse> evaluateDesigner(String designId, int rating);

  Future<BaseResponse<DesignResponseModel>> getDesignResponse(String designId);

  Stream<BaseResponse<DesignResponseModel>> getDesignRequestStream(
    String requestId,
  );
}
