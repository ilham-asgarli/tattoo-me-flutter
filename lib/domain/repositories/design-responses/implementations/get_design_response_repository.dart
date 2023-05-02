import '../../../../backend/features/design-responses/implementations/backend_get_design_response.dart';
import '../../../../core/base/models/base_response.dart';
import '../../../models/design-response/design_response_model.dart';
import '../interfaces/get_design_response_interface.dart';

class GetDesignResponseRepository extends GetDesignResponseInterface {
  BackendGetDesignResponse backendGetDesignResponse =
      BackendGetDesignResponse();

  @override
  Stream<BaseResponse<List<DesignResponseModel>>> getDesignResponseStream(
      String userId) {
    Stream<BaseResponse<List<DesignResponseModel>>> stream =
        backendGetDesignResponse.getDesignResponseStream(userId);
    return stream;
  }

  @override
  Future<BaseResponse<DesignResponseModel>> getDesignResponse(
      String designResponseId) async {
    BaseResponse<DesignResponseModel> baseResponse =
        await backendGetDesignResponse.getDesignResponse(designResponseId);
    return baseResponse;
  }
}
