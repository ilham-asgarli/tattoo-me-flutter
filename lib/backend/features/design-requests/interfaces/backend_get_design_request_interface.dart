import '../../../../core/base/models/base_response.dart';
import '../../../../domain/models/design-request/design_request_model.dart';

abstract class BackendGetDesignRequestInterface {
  Future<BaseResponse<DesignRequestModel>> getDesignRequest(
    String requestId,
  );

  Stream<BaseResponse<List<DesignRequestModel>>>
      getNotFinishedDesignRequestForDesignerStream(
    DesignRequestModel? designRequestModel,
  );
}
