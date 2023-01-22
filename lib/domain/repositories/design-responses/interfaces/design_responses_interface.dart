import '../../../../core/base/models/base_response.dart';
import '../../../models/design-response/design_response_model.dart';

abstract class DesignResponsesInterface {
  Future<BaseResponse> deleteDesign(String designId);

  Future<BaseResponse> evaluateDesigner(String designId, int rating);

  Future<BaseResponse<DesignResponseModel>> getDesignResponse(String requestId);

  Stream<BaseResponse<DesignResponseModel>> getDesignRequestStream(
    String requestId,
  );
}
