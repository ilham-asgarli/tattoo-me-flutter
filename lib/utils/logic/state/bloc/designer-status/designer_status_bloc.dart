import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../core/base/models/base_response.dart';
import '../../../../../core/base/models/base_success.dart';
import '../../../../../domain/repositories/design-requests/implementations/get_design_request_repository.dart';

part 'designer_status_event.dart';
part 'designer_status_state.dart';

class DesignerStatusBloc
    extends Bloc<DesignerStatusEvent, DesignerStatusState> {
  Stream<BaseResponse<int>> countStream = GetDesignRequestRepository()
      .backendGetDesignRequest
      .getMinRequestDesignerRequestCount();

  DesignerStatusBloc() : super(NoActiveDesigner()) {
    on<ChangeDesignerRequestCount>(onChangeDesignerCount);

    countStream.listen((event) {
      if (event is BaseSuccess<int>) {
        add(ChangeDesignerRequestCount(minRequestCount: event.data ?? -1));
      } else {
        add(const ChangeDesignerRequestCount(minRequestCount: -1));
      }
    });
  }

  void onChangeDesignerCount(
    ChangeDesignerRequestCount event,
    Emitter<DesignerStatusState> emit,
  ) {
    if (event.minRequestCount == -1) {
      emit(NoActiveDesigner());
    } else {
      emit(HasDesigner(minRequestCount: event.minRequestCount));
    }
  }
}
