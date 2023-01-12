import 'package:tattoo/domain/models/design-request/design_request_model.dart';
import 'package:tattoo/domain/repositories/design-requests/interfaces/send_design_request_interface.dart';

import '../../../../backend/features/design-requests/implementation/backend_send_design_request.dart';
import '../../../../core/base/models/base_success.dart';

class SendDesignRequestRepository extends SendDesignRequestInterface {
  BackendSendDesignRequest backendSendDesignRequest =
      BackendSendDesignRequest();

  @override
  Future<BaseSuccess<DesignRequestModel>> sendDesignRequest(
    DesignRequestModel designRequestModel,
  ) async {
    BaseSuccess<DesignRequestModel> baseResponse =
        await backendSendDesignRequest.sendDesignRequest(designRequestModel);
    return baseResponse;
  }

  @override
  Future<BaseSuccess<DesignRequestModel>> sendRetouchDesignRequest(
    DesignRequestModel designRequestModel,
    String comment,
  ) async {
    BaseSuccess<DesignRequestModel> baseResponse =
        await backendSendDesignRequest.sendRetouchDesignRequest(
      designRequestModel,
      comment,
    );
    return baseResponse;
  }
}
