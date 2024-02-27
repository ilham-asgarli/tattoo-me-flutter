import '../../../../domain/models/design-request/design_request_model.dart';

import '../../../../core/base/models/base_success.dart';

abstract class BackendSendDesignRequestInterface {
  Future<BaseSuccess<DesignRequestModel>> sendDesignRequest(
    DesignRequestModel designRequestModel,
  );

  Future<BaseSuccess<DesignRequestModel>> sendRetouchDesignRequest(
    DesignRequestModel designRequestModel,
    String comment,
  );
}
