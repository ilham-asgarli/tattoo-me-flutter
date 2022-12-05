import '../../../../core/base/models/base_response.dart';
import '../../../models/design-request/design_model.dart';

abstract class GetDesignRequestInterface {
  Future<BaseResponse<DesignModel>> getDesignRequest(
    String userId,
  );

  Stream<BaseResponse<List<DesignModel>>> getDesignRequestStream(
    String userId,
  );
}
