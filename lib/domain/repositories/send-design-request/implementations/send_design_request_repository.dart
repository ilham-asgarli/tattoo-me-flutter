import 'package:tattoo/backend/features/send-design-request/implementation/backend_send_design_request.dart';
import 'package:tattoo/core/base/models/base_response.dart';
import 'package:tattoo/domain/models/design-request/design_model.dart';
import 'package:tattoo/domain/repositories/send-design-request/interfaces/send_design_request_interface.dart';

class SendDesignRequestRepository extends SendDesignRequestInterface {
  BackendSendDesignRequest backendSendDesignRequest =
      BackendSendDesignRequest();

  @override
  Future<BaseResponse<DesignModel>> sendDesignRequest(
      DesignModel designRequestModel) async {
    BaseResponse<DesignModel> baseResponse =
        await backendSendDesignRequest.sendDesignRequest(designRequestModel);
    return baseResponse;
  }
}
