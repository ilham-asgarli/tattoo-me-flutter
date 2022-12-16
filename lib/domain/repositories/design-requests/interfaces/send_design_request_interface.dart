import '../../../../core/base/models/base_response.dart';
import '../../../models/design-request/design_request_model.dart';

abstract class SendDesignRequestInterface {
  Future<BaseResponse<DesignRequestModel>> sendDesignRequest(
    DesignRequestModel designRequestModel,
  );
}
