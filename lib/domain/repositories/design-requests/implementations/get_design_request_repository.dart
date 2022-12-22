import '../../../../backend/features/design-requests/implementation/backend_get_design_request.dart';
import '../../../../core/base/models/base_response.dart';
import '../../../models/design-request/design_request_model.dart';
import '../interfaces/get_design_request_interface.dart';

import '../../../models/design-response/design_response_model.dart';

class GetDesignRequestRepository extends GetDesignRequestInterface {
  BackendGetDesignRequest backendGetDesignRequest = BackendGetDesignRequest();

  @override
  Future<BaseResponse<DesignRequestModel>> getDesignRequest(
      String userId) async {
    BaseResponse<DesignRequestModel> baseResponse =
        await backendGetDesignRequest.getDesignRequest(userId);
    return baseResponse;
  }

  @override
  Stream<BaseResponse<List<DesignResponseModel>>> getDesignRequestStream(
      String userId) {
    Stream<BaseResponse<List<DesignResponseModel>>> stream =
        backendGetDesignRequest.getDesignRequestStream(userId);
    return stream;
  }

  @override
  Stream<BaseResponse<List<DesignRequestModel>>>
      getNotFinishedDesignRequestForDesignerStream(
          DesignRequestModel? designRequestModel) {
    Stream<BaseResponse<List<DesignRequestModel>>> stream =
        backendGetDesignRequest
            .getNotFinishedDesignRequestForDesignerStream(designRequestModel);
    return stream;
  }
}
