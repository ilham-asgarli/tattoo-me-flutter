import 'package:tattoo/backend/features/design-requests/implementation/backend_get_design_request.dart';
import 'package:tattoo/core/base/models/base_response.dart';
import 'package:tattoo/domain/models/design-request/design_request_model.dart';
import 'package:tattoo/domain/repositories/design-requests/interfaces/get_design_request_interface.dart';

import '../../../models/design-response/design_response_model.dart';

class GetDesignRequestRepository extends GetDesignRequestInterface {
  BackendGetDesignRequest backendGetDesignRequest = BackendGetDesignRequest();

  @override
  Future<BaseResponse<DesignRequestModel>> getDesignRequest(
      String userId) async {
    BaseResponse<DesignRequestModel> baseResponse =
        await backendGetDesignRequest.getDesignRequest(userId);
    return baseResponse;
  }

  @override
  Stream<BaseResponse<List<DesignResponseModel>>> getDesignRequestStream(
      String userId) {
    Stream<BaseResponse<List<DesignResponseModel>>> stream =
        backendGetDesignRequest.getDesignRequestStream(userId);
    return stream;
  }
}
