import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tattoo/core/base/models/base_success.dart';
import 'package:tattoo/domain/models/design-request/design_request_model.dart';
import 'package:tattoo/domain/repositories/design-requests/implementations/get_design_request_repository.dart';
import 'package:tattoo/domain/repositories/design-responses/implementations/design_responses_repository.dart';

import '../../../../../domain/models/design-response/design_response_model.dart';

part 'retouch_state.dart';

class RetouchCubit extends Cubit<RetouchState> {
  StreamSubscription? _readySubscription, _retouchSubscription;

  RetouchCubit(DesignRequestModel? designRequestModel)
      : super(RetouchInitial()) {
    listenToDesignStatus(designRequestModel);
  }

  void listenToDesignStatus(DesignRequestModel? designRequestModel) {
    GetDesignRequestRepository getDesignRequestRepository =
        GetDesignRequestRepository();
    DesignResponseRepository designResponseRepository =
        DesignResponseRepository();

    _retouchSubscription?.cancel();
    _readySubscription?.cancel();

    _retouchSubscription = getDesignRequestRepository
        .getNotFinishedDesignRequestForDesignerStream(designRequestModel)
        .listen((baseResponseList) {
      if (baseResponseList is BaseSuccess<List<DesignRequestModel>>) {
        if (baseResponseList.data == null) {
          return;
        }

        print(designRequestModel?.id);
        if (baseResponseList.data!.length > 3) {
          emit(RetouchInQueue(
            inQueueDesignRequestModels: baseResponseList.data,
          ));
        } else if (baseResponseList.data!.length <= 3 &&
            baseResponseList.data!.isNotEmpty) {
          emit(RetouchInRetouch(
            inRetouchDesignRequestModels: baseResponseList.data,
          ));
        } else {
          _retouchSubscription?.cancel();
        }
      }
    });

    _readySubscription = designResponseRepository
        .getDesignRequestStream(designRequestModel?.id ?? "")
        .listen((baseResponse) {
      if (baseResponse is BaseSuccess<DesignResponseModel>) {
        _retouchSubscription?.cancel();
        emit(RetouchIsReady(designResponseModel: baseResponse.data));
      }
    });
  }

  @override
  Future<void> close() {
    _retouchSubscription?.cancel();
    _readySubscription?.cancel();
    return super.close();
  }
}
