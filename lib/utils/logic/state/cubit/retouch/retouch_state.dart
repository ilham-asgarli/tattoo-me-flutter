part of 'retouch_cubit.dart';

@immutable
abstract class RetouchState extends Equatable {
  final bool inQueue = false;
  final bool inControl = false;
  final bool inRetouch = false;
  final bool isReady = false;

  @override
  List<Object> get props => [inQueue, inControl, inRetouch, isReady];
}

class RetouchInQueue extends RetouchState {
  @override
  bool get inQueue => true;

  @override
  List<Object> get props => [inQueue];
}

class RetouchInControl extends RetouchInQueue {
  @override
  bool get inControl => true;

  @override
  bool get inQueue => false;

  @override
  List<Object> get props => [inQueue, inControl];
}

class RetouchInRetouch extends RetouchInControl {
  @override
  bool get inRetouch => true;

  @override
  bool get inQueue => false;

  @override
  bool get inControl => false;

  @override
  List<Object> get props => [inQueue, inControl, inRetouch];
}

class RetouchIsReady extends RetouchInRetouch {
  @override
  bool get isReady => true;

  @override
  bool get inQueue => false;

  @override
  bool get inControl => false;

  @override
  bool get inRetouch => false;

  @override
  List<Object> get props => [inQueue, inControl, inRetouch, isReady];
}
