import 'package:tattoo/backend/features/design-responses/implementations/backend_design_request.dart';
import 'package:tattoo/core/base/models/base_response.dart';

import '../interfaces/design_responses_interface.dart';

class SendDesignRequestRepository extends DesignResponsesInterface {
  BackendDesignResponse backendDesignResponse = BackendDesignResponse();

  @override
  Future<BaseResponse> deleteDesign(String designId) async {
    BaseResponse baseResponse =
        await backendDesignResponse.deleteDesign(designId);
    return baseResponse;
  }

  @override
  Future<BaseResponse> evaluateDesigner(String designId, int rating) async {
    BaseResponse baseResponse =
        await backendDesignResponse.evaluateDesigner(designId, rating);
    return baseResponse;
  }
}
