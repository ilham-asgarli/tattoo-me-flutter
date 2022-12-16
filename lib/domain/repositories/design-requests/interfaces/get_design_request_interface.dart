import '../../../../core/base/models/base_response.dart';
import '../../../models/design-request/design_request_model.dart';
import '../../../models/design-response/design_response_model.dart';

abstract class GetDesignRequestInterface {
  Future<BaseResponse<DesignRequestModel>> getDesignRequest(
    String userId,
  );

  Stream<BaseResponse<List<DesignResponseModel>>> getDesignRequestStream(
    String userId,
  );
}
