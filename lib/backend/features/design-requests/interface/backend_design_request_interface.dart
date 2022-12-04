import 'package:tattoo/domain/models/design-request/design_model.dart';

import '../../../../core/base/models/base_response.dart';

abstract class BackendDesignRequestInterface {
  Future<BaseResponse<DesignModel>> createDesignRequest(
    DesignModel designRequestModel,
  );

  Future<BaseResponse> updateDesignRequest(
    DesignModel designRequestModel,
  );
}
