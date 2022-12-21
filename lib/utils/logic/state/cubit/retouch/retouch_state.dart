part of 'retouch_cubit.dart';

@immutable
abstract class RetouchState extends Equatable {
  @override
  List<Object> get props => [];
}

class RetouchInitial extends RetouchState {
  @override
  List<Object> get props => [];
}

class RetouchInQueue extends RetouchState {
  final List<DesignRequestModel>? inQueueDesignRequestModels;

  RetouchInQueue({required this.inQueueDesignRequestModels});

  @override
  List<Object> get props => [inQueueDesignRequestModels ?? []];
}

class RetouchInRetouch extends RetouchInQueue {
  final List<DesignRequestModel>? inRetouchDesignRequestModels;

  RetouchInRetouch({required this.inRetouchDesignRequestModels})
      : super(inQueueDesignRequestModels: null);

  @override
  List<Object> get props => [inRetouchDesignRequestModels ?? []];
}

class RetouchIsReady extends RetouchInRetouch {
  final DesignResponseModel? designResponseModel;

  RetouchIsReady({required this.designResponseModel})
      : super(inRetouchDesignRequestModels: null);

  @override
  List<Object> get props => [designResponseModel ?? DesignResponseModel()];
}
