import '../../../../core/base/models/base_response.dart';
import '../../../../domain/models/settings/settings_model.dart';

abstract class SettingsInterface {
  Stream<BaseResponse<SettingsModel>> getDesignRequestsSettingsStream();
}
