import 'package:tattoo/backend/features/design-requests/implementation/backend_get_design_request.dart';
import 'package:tattoo/core/base/models/base_response.dart';
import 'package:tattoo/domain/models/design-request/design_model.dart';
import 'package:tattoo/domain/repositories/design-request/interfaces/get_design_request_interface.dart';

class GetDesignRequestRepository extends GetDesignRequestInterface {
  BackendGetDesignRequest backendGetDesignRequest = BackendGetDesignRequest();

  @override
  Future<BaseResponse<DesignModel>> getDesignRequest(String userId) async {
    BaseResponse<DesignModel> baseResponse =
        await backendGetDesignRequest.getDesignRequest(userId);
    return baseResponse;
  }

  @override
  Stream<BaseResponse<List<DesignModel>>> getDesignRequestStream(
      String userId) {
    Stream<BaseResponse<List<DesignModel>>> stream =
        backendGetDesignRequest.getDesignRequestStream(userId);
    return stream;
  }
}
