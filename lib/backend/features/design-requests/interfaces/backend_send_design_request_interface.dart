import 'package:tattoo/domain/models/design-request/design_request_model.dart';

import '../../../../core/base/models/base_response.dart';

abstract class BackendSendDesignRequestInterface {
  Future<BaseResponse<DesignRequestModel>> sendDesignRequest(
    DesignRequestModel designRequestModel,
  );

  Future<BaseResponse<DesignRequestModel>> sendRetouchDesignRequest(
    DesignRequestModel designRequestModel,
    String comment,
  );
}
