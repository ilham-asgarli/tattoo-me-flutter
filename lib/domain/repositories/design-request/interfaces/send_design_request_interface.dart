import '../../../../core/base/models/base_response.dart';
import '../../../models/design-request/design_model.dart';

abstract class SendDesignRequestInterface {
  Future<BaseResponse<DesignModel>> sendDesignRequest(
    DesignModel designRequestModel,
  );
}
