import '../../../../core/base/models/base_success.dart';
import '../../../models/design-request/design_request_model.dart';

abstract class SendDesignRequestInterface {
  Future<BaseSuccess<DesignRequestModel>> sendDesignRequest(
    DesignRequestModel designRequestModel,
  );

  Future<BaseSuccess<DesignRequestModel>> sendRetouchDesignRequest(
    DesignRequestModel designRequestModel,
    String comment,
  );
}
