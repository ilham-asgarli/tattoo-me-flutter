import 'package:tattoo/backend/features/design-requests/implementation/backend_send_design_request.dart';
import 'package:tattoo/core/base/models/base_response.dart';
import 'package:tattoo/domain/models/design-request/design_request_model.dart';
import 'package:tattoo/domain/repositories/design-requests/interfaces/send_design_request_interface.dart';

class SendDesignRequestRepository extends SendDesignRequestInterface {
  BackendSendDesignRequest backendSendDesignRequest =
      BackendSendDesignRequest();

  @override
  Future<BaseResponse<DesignRequestModel>> sendDesignRequest(
    DesignRequestModel designRequestModel,
  ) async {
    BaseResponse<DesignRequestModel> baseResponse =
        await backendSendDesignRequest.sendDesignRequest(designRequestModel);
    return baseResponse;
  }
}
