import '../../../../backend/features/design-responses/implementations/backend_design_response.dart';
import '../../../../core/base/models/base_response.dart';

import '../../../models/design-response/design_response_model.dart';
import '../interfaces/design_responses_interface.dart';

class DesignResponseRepository extends DesignResponsesInterface {
  BackendDesignResponse backendDesignResponse = BackendDesignResponse();

  @override
  Future<BaseResponse> deleteDesign(String designId) async {
    BaseResponse baseResponse =
        await backendDesignResponse.deleteDesign(designId);
    return baseResponse;
  }

  @override
  Future<BaseResponse> evaluateDesigner(String designId, int rating) async {
    BaseResponse baseResponse =
        await backendDesignResponse.evaluateDesigner(designId, rating);
    return baseResponse;
  }

  @override
  Future<BaseResponse<DesignResponseModel>> getDesignResponse(
      String requestId) async {
    BaseResponse<DesignResponseModel> baseResponse =
        await backendDesignResponse.getDesignResponse(requestId);
    return baseResponse;
  }

  @override
  Stream<BaseResponse<DesignResponseModel>> getDesignRequestStream(
      String requestId) {
    Stream<BaseResponse<DesignResponseModel>> stream =
        backendDesignResponse.getDesignRequestStream(requestId);
    return stream;
  }
}
