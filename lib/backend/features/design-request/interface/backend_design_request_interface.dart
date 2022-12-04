import 'package:tattoo/domain/models/design-request/design_request_model.dart';

import '../../../../core/base/models/base_response.dart';

abstract class BackendDesignRequestInterface {
  Future<BaseResponse<DesignRequestModel>> createDesignRequest(
    DesignRequestModel designRequestModel,
  );

  Future<BaseResponse> updateDesignRequest(
    DesignRequestModel designRequestModel,
  );
}
