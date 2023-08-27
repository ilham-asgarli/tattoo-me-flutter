import '../../../../backend/features/design-requests/implementation/backend_get_design_request.dart';
import '../../../../core/base/models/base_response.dart';
import '../../../models/design-request/design_request_model.dart';
import '../interfaces/get_design_request_interface.dart';

class GetDesignRequestRepository extends GetDesignRequestInterface {
  BackendGetDesignRequest backendGetDesignRequest = BackendGetDesignRequest();

  @override
  Future<BaseResponse<DesignRequestModel>> getDesignRequest(
      String requestId) async {
    BaseResponse<DesignRequestModel> baseResponse =
        await backendGetDesignRequest.getDesignRequest(requestId);
    return baseResponse;
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

  @override
  Stream<BaseResponse<int>> getMinDesignerRequestCount() {
    Stream<BaseResponse<int>> stream =
        backendGetDesignRequest.getMinRequestDesignerRequestCount();
    return stream;
  }
}
