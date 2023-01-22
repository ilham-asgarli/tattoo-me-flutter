import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../../core/base/models/base_success.dart';
import '../../../../../domain/models/design-request/design_request_model.dart';
import '../../../../../domain/models/design-response/design_response_model.dart';
import '../../../../../domain/repositories/design-requests/implementations/get_design_request_repository.dart';
import '../../../../../domain/repositories/design-responses/implementations/design_responses_repository.dart';

part 'retouch_state.dart';

class RetouchCubit extends Cubit<RetouchState> {
  StreamSubscription? _readySubscription, _retouchSubscription;
  final DesignRequestModel? designRequestModel;

  RetouchCubit(this.designRequestModel)
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
        .listen((baseResponseList) async {
      if (baseResponseList is BaseSuccess<List<DesignRequestModel>>) {
        if (baseResponseList.data == null) {
          return;
        }

        int retouchLimit = 2;

        if (baseResponseList.data!.last.startDesignDate != null) {
          emit(RetouchInRetouch(
            inRetouchDesignRequestModels: baseResponseList.data,
          ));
        } else if (baseResponseList.data!.length >= retouchLimit) {
          emit(RetouchInQueue(
            inQueueDesignRequestModels: baseResponseList.data,
          ));
        } else if (baseResponseList.data!.length < retouchLimit &&
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

        DesignResponseModel? designResponseModel = baseResponse.data;
        designResponseModel?.designRequestModel = designRequestModel;

        emit(RetouchIsReady(designResponseModel: designResponseModel));
      }
    });
  }

  void inQueue(List<DesignRequestModel>? designRequestModels) {
    emit(RetouchInQueue(
      inQueueDesignRequestModels: designRequestModels,
    ));
  }

  @override
  Future<void> close() {
    _retouchSubscription?.cancel();
    _readySubscription?.cancel();
    return super.close();
  }
}
