import '../../../../core/base/models/base_response.dart';

abstract class DesignResponsesInterface {
  Future<BaseResponse> deleteDesign(String designId);
  Future<BaseResponse> evaluateDesigner(String designId, int rating);
}
