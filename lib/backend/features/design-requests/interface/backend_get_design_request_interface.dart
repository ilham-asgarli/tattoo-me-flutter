import '../../../../core/base/models/base_response.dart';
import '../../../../domain/models/design-request/design_model.dart';

abstract class BackendGetDesignRequestInterface {
  Future<BaseResponse<DesignModel>> getDesignRequest(
    String userId,
  );

  Stream<BaseResponse<List<DesignModel>>> getDesignRequestStream(
    String userId,
  );
}
