import '../../../../core/base/models/base_response.dart';
import '../../../models/design-response/design_response_model.dart';

abstract class GetDesignResponseInterface {
  Stream<BaseResponse<List<DesignResponseModel>>> getDesignResponseStream(
    String userId,
  );

  Future<BaseResponse<DesignResponseModel>> getDesignResponse(
    String designResponseId,
  );
}
