import '../../../../core/base/view-models/base_view_model.dart';
import '../../../../domain/repositories/design-requests/implementations/get_design_request_repository.dart';

class ReadyViewModel extends BaseViewModel {
  GetDesignRequestRepository getDesignRequestRepository =
      GetDesignRequestRepository();
}
