import 'package:tattoo/core/base/view-models/base_view_model.dart';
import 'package:tattoo/domain/repositories/design-request/implementations/get_design_request_repository.dart';

class ReadyViewModel extends BaseViewModel {
  GetDesignRequestRepository getDesignRequestRepository =
      GetDesignRequestRepository();
}
