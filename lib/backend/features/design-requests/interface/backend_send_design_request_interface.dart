import 'package:tattoo/domain/models/design-request/design_model.dart';

import '../../../../core/base/models/base_response.dart';

abstract class BackendSendDesignRequestInterface {
  Future<BaseResponse<DesignModel>> sendDesignRequest(
    DesignModel designRequestModel,
  );
}
